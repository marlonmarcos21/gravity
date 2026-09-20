# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Gravity is a Rails 7.2 social-network app (Ruby 3.4.9, PostgreSQL, Redis, Sidekiq) with
posts, blogs, recipes, events, threaded comments, likes, friend requests, activity
notifications, and real-time chat. Views are HAML + Sprockets/jQuery, with a small
React island (Shakapacker) for chat and a scroll-up button.

## Commands

```bash
bundle install && yarn install
bin/rails db:setup                 # or db:create db:schema:load (schema_format is :sql -> db/structure.sql)
bin/rails db:test:prepare          # test DB
bin/rails s                        # Puma
bin/webpacker-dev-server           # Shakapacker dev server (optional; `compile: true` in development)
bundle exec sidekiq -C config/sidekiq.yml   # background jobs (required for media processing)

bin/rspec                          # full suite
bin/rspec spec/models/post_spec.rb # single file
bin/rspec spec/models/post_spec.rb:42  # single example
bin/parallel_rspec spec -o '--options .rspec_parallel'  # parallel (uses gravity_test<N> DBs)
bin/rubocop                        # lints app/**/*.rb and config/**/*.rb only
bin/annotate                       # refresh schema annotations in models/factories
```

Postgres and Redis (versions in `.tool-versions`) must both be running; Redis is needed
for the media-token sets, Action Cable and Sidekiq, and specs fail at `FactoryBot.lint`
without it. `config/database.yml` sets no username in development, so Postgres needs a
role matching your OS user.

`.env` (see `.env.example`) is loaded via dotenv-rails in development/test. AWS keys are
required for anything that touches media.

Do not set `BUNDLE_BIN` (e.g. `bundle config bin bin`): it makes every `bundle install`
overwrite `bin/rails`, `bin/rake` and `bin/setup` with Bundler binstubs, and the Rails
ones stop working (`rails runner` falls through to printing `rails new` usage). Restore
them with `git checkout -- bin/` if that happens.

## Architecture notes

### Media uploads are a 3-phase, out-of-band flow
Posts do **not** upload through Rails. The browser gets a presigned S3 POST
(`GET /posts/presigned_url`), uploads directly, then calls back
(`GET /posts/media_upload_callback`) which creates an `Image` or `Video` row carrying a
`media_token` and the S3 `key` but no attachable. On `create`/`update` the controller
calls `attach_media` to claim all rows with that token by setting `attachable_id`.

`Image`/`Video` `after_commit on: :create` register themselves in a Redis set keyed by
the media token (`REDIS.sadd(token, "image-#{id}")`) and enqueue `ImageJob`/`VideoJob`,
which download from S3, run Paperclip styles / ffmpeg metadata, then `srem` themselves.
`GET /posts/pre_post_check` polls whether that Redis set is empty — i.e. whether media
is done processing. If you change job or model callbacks, keep the sadd/srem pairing
intact or the client will hang.

Deletes are also deferred: the controller nulls `attachable_id` and enqueues
`ImageJob`/`VideoJob` with `'delete'`.

### Object storage is a self-hosted S3 gateway (versitygw), not AWS
Everything S3 is built from `S3::CLIENT_OPTIONS` in `config/initializers/s3.rb`
(`BUCKET`, Paperclip via `S3::PAPERCLIP_OPTIONS` + `config/s3.yml`, and Shrine).
Change connection settings there, not per model. Env vars: `AWS_S3_ENDPOINT`,
`AWS_S3_BUCKET`, `AWS_S3_PUBLIC_HOST`, `AWS_S3_FORCE_PATH_STYLE`.

**Two buckets, one connection.** `AWS_S3_BUCKET` (`static-dev`) is private: its
objects are only reachable through presigned URLs, and that is where post media
(`Image`/`Video`), chat attachments and recipe media live. `AWS_S3_PUBLIC_BUCKET`
is served anonymously, so its URLs are plain and never expire, and holds
everything served without a signature: **blog media, profile photos, the default
avatar and the site chrome under `assets/`**. Blog media and profile photos get
embedded in stored HTML (TinyMCE bodies, cached JSON), which a presigned URL would
break once the signature lapsed. `S3.public_bucket_url` builds those URLs; the
bucket name is the host label, so the host is derived, not configured separately. Attachments opt in with `S3::PUBLIC_PAPERCLIP_OPTIONS`
instead of `S3::PAPERCLIP_OPTIONS`; both derive from the same `CLIENT_OPTIONS`.

Two Paperclip gotchas are encoded in `S3::PUBLIC_PAPERCLIP_OPTIONS`: `url:
':s3_alias_url'` is needed so the public host is used verbatim (otherwise
Paperclip builds `<bucket>.<s3_host_name>`, i.e.
`static-public.static-public.gravity.ph`), and setting that `:url` makes Paperclip
skip deriving `:path`, so `:path` must be given explicitly or interpolation
recurses (`InfiniteInterpolationError`). The explicit value reproduces the key
layout Paperclip would otherwise derive, so keys are identical in both buckets.

**Addressing is virtual-host, and `AWS_S3_ENDPOINT` is the PARENT domain**
(`https://gravity.ph`, not `https://static-dev.gravity.ph`). The gateway reads the
bucket from the Host header and treats the whole path as the key, so an object
lives at `https://static-dev.gravity.ph/<key>` with no bucket segment, and the
SDK reproduces that by joining bucket onto the endpoint host.

The trap: pointing the endpoint at the bucket's own host with
`force_path_style: true` also "works" -- writes return 200 -- but requests go to
`/static-dev/<key>` and the gateway stores `static-dev/<key>` as the key. Uploads
then land in a namespace where the existing objects (`assets/`, `dev_files/`,
`store/`) are not, and `HeadBucket`/`ListObjects` fail because the gateway is
resolving `static-dev` as an object name. If `/static-dev/...` shows up in a URL,
this is why.

What the gateway actually does and does not support (all re-verified under the
addressing above -- several apparent "missing APIs" were symptoms of getting the
addressing wrong, so re-test before believing any such claim):
- **`${filename}` in a POST policy is NOT expanded.** POST-object itself works
  (201), but the object is stored under the literal key `.../${filename}`. That
  is why post media uploads via a **presigned PUT** instead: `GET
  /posts/presigned_url` returns `{url, key, uuid}` with the key decided
  server-side, and the Dropzone in `app/views/posts/_form.html.haml` overrides
  `submitRequest` to send the raw file as the request body. A stray object keyed
  `${filename}` is the signature of the old POST flow.
- **No ACL APIs.** `PutObjectAcl`/`GetObjectAcl` return NotImplemented, so never
  call `object.acl.put`; visibility is a gateway-side setting. An `acl:` argument
  passed to `put_object` is accepted and ignored.
- `CopyObject`, `ListObjectsV2`, `HeadBucket`, multipart and presigned GET/PUT all
  work. `ListBuckets` returns unparseable XML, but nothing in the app calls it.
- aws-sdk-s3 >= 1.178 sends CRC32 integrity headers by default; both checksum
  options are pinned to `when_required` because the gateway does not implement them.
- **`AWS_S3_REGION` must match the gateway's region** (`us-east-1`). It validates
  the SigV4 credential scope and rejects anything else with
  `AuthorizationHeaderMalformed`. Dropping the variable does not fall back to a
  safe default -- the SDK silently picks up `~/.aws/config`.

Reads split two ways: user media (posts, blogs, chat attachments) is private and
served through presigned URLs; site chrome (`assets/`, `dev_files/`) and recipe
media (`store/`) are unsigned via `S3.public_url`, which requires the gateway to
serve those prefixes anonymously. Recipe media *must* stay unsigned because
`trix_upload.js` writes the URL into the stored Action Text body, where an
expiring URL would rot.

`config/s3.yml` is deliberately written without YAML anchors: Paperclip loads it
with `YAML.load`, and Psych 4 raises `AliasesNotEnabled` on `<<: *default`.

### Three coexisting attachment stacks
- **Paperclip** (`Image` via `WithAttachment`, `BlogMedium`, `User#profile_photo`, `Chat::MessageAttachment`) — options from `S3::PAPERCLIP_OPTIONS`; `source_url` returns a presigned URL normalised to port-less https. `Video` is *not* Paperclip; it stores a raw `key` and signs URLs via `S3.presigned_url`.
- **Shrine** (`RecipeMedium` via `ImageUploader[:file]`) — `public: true`, `cache`/`store` prefixes.
- **ActionText/Trix** for `Recipe` (description/ingredients/instructions) and `Event#body`; blog bodies use TinyMCE instead (`POST /blogs/tinymce_assets`).

Active Storage is only half-present: `config/application.rb` leaves its `require` commented
out, but `action_text/engine` requires it anyway, so it *is* loaded. Since Rails 7.1 the
`has_many_attached` that `has_rich_text` declares raises unless `config.active_storage.service`
is set, which is why each environment sets one. Nothing is actually stored there -- Trix
attachments POST to `/recipe_media.json` (Shrine -> S3), see `app/javascript/packs/trix_upload.js`.

`config/initializers/action_text.rb` adds an `ActionText::Attachables::RemoteVideo` (upstream
only recognises remote *images*) and extends the sanitizer allow-lists. Those lists must keep
including `ActionText::Attachment.tag_name`, or every attachment is silently stripped on render.

`BUCKET` (global, `config/initializers/s3.rb`) and `REDIS` (`config/initializers/redis.rb`)
are bare global constants used directly from models, jobs and controllers.

### Authorization
CanCanCan with a single `Ability` class. **User id 1 is a superuser** (`can :manage, :all`)
and is also the only user allowed at `/sidekiq`. Controllers use
`load_and_authorize_resource`; `ApplicationController` rescues `CanCan::AccessDenied` and
returns JSON + `X-Message` headers for XHR, otherwise redirects to the referer.

### AJAX conventions
Flash messages for XHR requests are moved into `X-Message` / `X-Message-Type` response
headers by `flash_to_headers`. Infinite scroll is server-rendered: each `more_published_*`
action renders a `.js.erb` that appends a partial and rebinds a `$(window).scroll` handler
(see `app/views/posts/more_published_posts.js.erb`).

### Chat (real-time)
`GravityChannel` is the single ActionCable channel. It streams *for* a `Chat::Group` and
also *from* `"chat_group_#{id}"` when `params[:chat_list]` is set (so the conversation list
updates live). The channel itself persists messages: `receive` builds `Chat::Message` plus
one `outbox` receipt for the sender and an `inbox` receipt per other participant, then
enqueues `MessageAttachmentJob` in an `after_commit`. React components
(`app/javascript/components/Chat.js`, `ChatList.js`) talk to `ChatsController` JSON
endpoints for history and to the channel for live traffic.

### Counters and caching
Notification and unread-message badges are `Rails.cache.fetch` values keyed
`user/<id>/notification-count` and `user/<id>/message-count`; they are invalidated by
explicit `Rails.cache.delete` calls in `Activity#clear_notifications_count`,
`ApplicationController`, and `GravityChannel#update_receipts`. Category lists are cached
under `recipe-categories` / `blog-categories`. Any new write path that changes these
counts must delete the key.

### Search
pg_search with `tsvector` columns (`tsv_name`) maintained in the database, plus trigram
fallback. `SearchController` sanitizes the term and searches users, posts and blogs
separately.

### Content rendering
`PostView#embed_videos` rewrites stored HTML at render time: it finds `<a>` tags and
injects YouTube iframes and TikTok `blockquote.tiktok-embed` markup. `BlogView` provides
the teaser/sanitize helpers for blog bodies.
`Post#unfurl_tiktok_short_url` resolves `https://vt.tiktok.com` short links to canonical
URLs in a `before_save` (a live HTTP call). The TikTok `embed.js` script must be
re-inserted after AJAX-appended pages.

### Categories use STI on a non-standard column
`Category` sets `self.inheritance_column = :model` with an enum, and overrides
`find_sti_class`/`sti_name` so subclasses live at `Category::Blog` / `Category::Recipe`
while the column stores `"Blog"` / `"Recipe"`. `Category.Blog` (enum scope) is how
controllers/helpers fetch each set.

### Version constraints that exist for a reason
`json` is held at 2.x (ActiveSupport 7.2 calls `JSON.generate`/`parse` with `quirks_mode:`,
removed in json 3.0 -- with json 3 every `to_json` in the app raises).
`connection_pool` is held at 2.x (3.0 made `TimedStack#pop` keyword-only, which kills
Sidekiq 7's scheduler thread). `sidekiq` is held at 7.x because 8 refuses to boot against
a Redis server older than 7.0, and `.tool-versions` pins redis 6.2.6. Relaxing any of
these means also moving Rails to 8.x / Redis to 7.x.

`twitter-bootstrap-rails` is held at 5.0.0, which is the **only** source of Bootstrap CSS
and JS in this app (`bootstrap_and_overrides.css` pulls
`twitter-bootstrap-static/bootstrap`; `app/assets/javascripts/application.js` pulls
`twitter/bootstrap`). 5.0.0 ships Bootstrap 3.1.1; 5.4.0 ships Bootstrap 5.3.8. Every
layout and view here is Bootstrap 3 markup (`navbar-fixed-top`, `navbar-header`,
`navbar-toggle`, `navbar-collapse`, `btn-default`, `data-toggle`), so letting this gem
float silently swaps the framework underneath the markup: the navbar's
`.navbar-main-collapse` keeps Bootstrap 5's `.collapse { display: none }` with none of
Bootstrap 3's `@media (min-width: 768px) { .navbar-collapse.collapse { display: block } }`,
and the whole header -- menus, Sign In button, dark-mode toggle -- disappears. `bootstrap-sass`
is in the Gemfile but is *not* imported by any stylesheet, so it does not cover for this.

### Misc
- Generators produce HAML (`config.generators template_engine: :haml`).
- `action_on_unpermitted_parameters = :raise` — strong params mistakes fail loudly.
- Time zone is `Eastern Time (US & Canada)`.
- Dark mode is a permanent `dark_mode` cookie that swaps the stylesheet in the layout.
- `friendly_id` slugs on `User`, `Category`, `Blog`, `Recipe`, `Event` (`Post` has a `slug` column but is not friendly_id'd); `paper_trail` versions `Post#body`; `public_activity` writes `Activity` rows via `tracked skip_defaults: true` and explicit `create_activity` calls.
- Specs are model/controller/channel/mailer only (no feature specs); DatabaseCleaner with transactions, `use_transactional_fixtures = false`, FactoryBot, shoulda-matchers, VCR cassettes in `spec/factories/vcr`. Shared context `'with_authentication'` signs in a user for controller specs.
