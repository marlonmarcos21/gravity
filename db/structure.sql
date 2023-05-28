SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: action_text_rich_texts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.action_text_rich_texts (
    id bigint NOT NULL,
    name character varying NOT NULL,
    body text,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: action_text_rich_texts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.action_text_rich_texts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: action_text_rich_texts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.action_text_rich_texts_id_seq OWNED BY public.action_text_rich_texts.id;


--
-- Name: active_storage_attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_attachments (
    id bigint NOT NULL,
    name character varying NOT NULL,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    blob_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_attachments_id_seq OWNED BY public.active_storage_attachments.id;


--
-- Name: active_storage_blobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_blobs (
    id bigint NOT NULL,
    key character varying NOT NULL,
    filename character varying NOT NULL,
    content_type character varying,
    metadata text,
    service_name character varying NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_blobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_blobs_id_seq OWNED BY public.active_storage_blobs.id;


--
-- Name: active_storage_variant_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_variant_records (
    id bigint NOT NULL,
    blob_id bigint NOT NULL,
    variation_digest character varying NOT NULL
);


--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_variant_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_variant_records_id_seq OWNED BY public.active_storage_variant_records.id;


--
-- Name: activities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.activities (
    id integer NOT NULL,
    trackable_id integer,
    trackable_type character varying,
    owner_id integer,
    owner_type character varying,
    key character varying,
    parameters text,
    recipient_id integer,
    recipient_type character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    is_read boolean DEFAULT false
);


--
-- Name: activities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.activities_id_seq OWNED BY public.activities.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: blog_media; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.blog_media (
    id integer NOT NULL,
    source_file_name character varying,
    source_content_type character varying,
    source_file_size integer,
    source_updated_at timestamp without time zone,
    attachable_id integer,
    attachable_type character varying,
    token character varying,
    width integer,
    height integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: blog_media_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.blog_media_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: blog_media_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.blog_media_id_seq OWNED BY public.blog_media.id;


--
-- Name: blogs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.blogs (
    id integer NOT NULL,
    title character varying,
    body text,
    published boolean DEFAULT false,
    published_at timestamp without time zone,
    user_id integer,
    slug character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    tsv_name tsvector,
    category_id bigint
);


--
-- Name: blogs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.blogs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: blogs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.blogs_id_seq OWNED BY public.blogs.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categories (
    id bigint NOT NULL,
    title character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    slug character varying,
    model character varying
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: chat_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chat_groups (
    id bigint NOT NULL,
    chat_room_name character varying,
    is_group_chat boolean DEFAULT false,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: chat_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chat_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chat_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.chat_groups_id_seq OWNED BY public.chat_groups.id;


--
-- Name: chat_groups_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chat_groups_users (
    id bigint NOT NULL,
    user_id bigint,
    chat_group_id bigint,
    is_read boolean DEFAULT true,
    joined boolean DEFAULT true,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: chat_groups_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chat_groups_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chat_groups_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.chat_groups_users_id_seq OWNED BY public.chat_groups_users.id;


--
-- Name: chat_message_attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chat_message_attachments (
    id bigint NOT NULL,
    source_content_type character varying,
    source_file_name character varying,
    source_file_size integer,
    source_updated_at timestamp without time zone,
    chat_message_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: chat_message_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chat_message_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chat_message_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.chat_message_attachments_id_seq OWNED BY public.chat_message_attachments.id;


--
-- Name: chat_message_receipts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chat_message_receipts (
    id bigint NOT NULL,
    user_id bigint,
    chat_group_id bigint,
    chat_message_id bigint,
    is_read boolean DEFAULT false,
    receipt_type character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: chat_message_receipts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chat_message_receipts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chat_message_receipts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.chat_message_receipts_id_seq OWNED BY public.chat_message_receipts.id;


--
-- Name: chat_messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chat_messages (
    id bigint NOT NULL,
    chat_group_id bigint,
    sender_id bigint,
    body text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: chat_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chat_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chat_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.chat_messages_id_seq OWNED BY public.chat_messages.id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.comments (
    id integer NOT NULL,
    commentable_id integer,
    commentable_type character varying,
    title character varying,
    body text,
    subject character varying,
    user_id integer NOT NULL,
    parent_id integer,
    lft integer,
    rgt integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.comments_id_seq OWNED BY public.comments.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.events (
    id bigint NOT NULL,
    title character varying NOT NULL,
    published boolean DEFAULT false,
    user_id bigint NOT NULL,
    published_at timestamp without time zone,
    slug character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    og_image_source text
);


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;


--
-- Name: friend_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.friend_requests (
    id integer NOT NULL,
    user_id integer,
    requester_id integer,
    status character varying DEFAULT 'pending'::character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: friend_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.friend_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: friend_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.friend_requests_id_seq OWNED BY public.friend_requests.id;


--
-- Name: friends; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.friends (
    id integer NOT NULL,
    user_id integer,
    friend_id integer,
    friend_request_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: friends_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.friends_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: friends_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.friends_id_seq OWNED BY public.friends.id;


--
-- Name: images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.images (
    id integer NOT NULL,
    source_file_name character varying,
    source_content_type character varying,
    source_file_size integer,
    source_updated_at timestamp without time zone,
    attachable_id integer,
    attachable_type character varying,
    main_image boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    token character varying,
    width integer,
    height integer,
    key character varying
);


--
-- Name: images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.images_id_seq OWNED BY public.images.id;


--
-- Name: likes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.likes (
    id bigint NOT NULL,
    user_id bigint,
    trackable_type character varying,
    trackable_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: likes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.likes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: likes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.likes_id_seq OWNED BY public.likes.id;


--
-- Name: posts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.posts (
    id integer NOT NULL,
    body text,
    published boolean DEFAULT true,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    published_at timestamp without time zone,
    tsv_name tsvector,
    slug character varying,
    public boolean DEFAULT false
);


--
-- Name: posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.posts_id_seq OWNED BY public.posts.id;


--
-- Name: recipe_media; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.recipe_media (
    id bigint NOT NULL,
    file_data text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    user_id bigint,
    video_meta jsonb DEFAULT '{}'::jsonb,
    s3_id character varying
);


--
-- Name: recipe_media_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.recipe_media_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: recipe_media_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.recipe_media_id_seq OWNED BY public.recipe_media.id;


--
-- Name: recipes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.recipes (
    id bigint NOT NULL,
    title character varying,
    published boolean DEFAULT false,
    user_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    slug character varying,
    category_id bigint,
    published_at timestamp without time zone
);


--
-- Name: recipes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.recipes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: recipes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.recipes_id_seq OWNED BY public.recipes.id;


--
-- Name: rsvps; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rsvps (
    id bigint NOT NULL,
    event_id bigint NOT NULL,
    name character varying NOT NULL,
    email character varying,
    phone character varying,
    notes text,
    status character varying NOT NULL,
    parent_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: rsvps_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.rsvps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rsvps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.rsvps_id_seq OWNED BY public.rsvps.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: user_profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_profiles (
    id integer NOT NULL,
    date_of_birth date,
    street_address1 character varying,
    street_address2 character varying,
    city character varying,
    state character varying,
    country character varying,
    postal_code character varying,
    phone_number character varying,
    mobile_number character varying,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: user_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_profiles_id_seq OWNED BY public.user_profiles.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    active boolean DEFAULT true,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    profile_photo_file_name character varying,
    profile_photo_content_type character varying,
    profile_photo_file_size integer,
    profile_photo_updated_at timestamp without time zone,
    first_name character varying,
    last_name character varying,
    tsv_name tsvector,
    slug character varying
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.versions (
    id integer NOT NULL,
    item_type character varying NOT NULL,
    item_id integer NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object text,
    created_at timestamp without time zone
);


--
-- Name: versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.versions_id_seq OWNED BY public.versions.id;


--
-- Name: videos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.videos (
    id integer NOT NULL,
    source_meta json,
    attachable_id integer,
    attachable_type character varying,
    token character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    key character varying
);


--
-- Name: videos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.videos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: videos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.videos_id_seq OWNED BY public.videos.id;


--
-- Name: action_text_rich_texts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.action_text_rich_texts ALTER COLUMN id SET DEFAULT nextval('public.action_text_rich_texts_id_seq'::regclass);


--
-- Name: active_storage_attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('public.active_storage_attachments_id_seq'::regclass);


--
-- Name: active_storage_blobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('public.active_storage_blobs_id_seq'::regclass);


--
-- Name: active_storage_variant_records id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records ALTER COLUMN id SET DEFAULT nextval('public.active_storage_variant_records_id_seq'::regclass);


--
-- Name: activities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities ALTER COLUMN id SET DEFAULT nextval('public.activities_id_seq'::regclass);


--
-- Name: blog_media id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blog_media ALTER COLUMN id SET DEFAULT nextval('public.blog_media_id_seq'::regclass);


--
-- Name: blogs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blogs ALTER COLUMN id SET DEFAULT nextval('public.blogs_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: chat_groups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_groups ALTER COLUMN id SET DEFAULT nextval('public.chat_groups_id_seq'::regclass);


--
-- Name: chat_groups_users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_groups_users ALTER COLUMN id SET DEFAULT nextval('public.chat_groups_users_id_seq'::regclass);


--
-- Name: chat_message_attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_message_attachments ALTER COLUMN id SET DEFAULT nextval('public.chat_message_attachments_id_seq'::regclass);


--
-- Name: chat_message_receipts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_message_receipts ALTER COLUMN id SET DEFAULT nextval('public.chat_message_receipts_id_seq'::regclass);


--
-- Name: chat_messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_messages ALTER COLUMN id SET DEFAULT nextval('public.chat_messages_id_seq'::regclass);


--
-- Name: comments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.comments_id_seq'::regclass);


--
-- Name: events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);


--
-- Name: friend_requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.friend_requests ALTER COLUMN id SET DEFAULT nextval('public.friend_requests_id_seq'::regclass);


--
-- Name: friends id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.friends ALTER COLUMN id SET DEFAULT nextval('public.friends_id_seq'::regclass);


--
-- Name: images id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.images ALTER COLUMN id SET DEFAULT nextval('public.images_id_seq'::regclass);


--
-- Name: likes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.likes ALTER COLUMN id SET DEFAULT nextval('public.likes_id_seq'::regclass);


--
-- Name: posts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.posts ALTER COLUMN id SET DEFAULT nextval('public.posts_id_seq'::regclass);


--
-- Name: recipe_media id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recipe_media ALTER COLUMN id SET DEFAULT nextval('public.recipe_media_id_seq'::regclass);


--
-- Name: recipes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recipes ALTER COLUMN id SET DEFAULT nextval('public.recipes_id_seq'::regclass);


--
-- Name: rsvps id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rsvps ALTER COLUMN id SET DEFAULT nextval('public.rsvps_id_seq'::regclass);


--
-- Name: user_profiles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_profiles ALTER COLUMN id SET DEFAULT nextval('public.user_profiles_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: versions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.versions ALTER COLUMN id SET DEFAULT nextval('public.versions_id_seq'::regclass);


--
-- Name: videos id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.videos ALTER COLUMN id SET DEFAULT nextval('public.videos_id_seq'::regclass);


--
-- Name: action_text_rich_texts action_text_rich_texts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.action_text_rich_texts
    ADD CONSTRAINT action_text_rich_texts_pkey PRIMARY KEY (id);


--
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- Name: active_storage_variant_records active_storage_variant_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT active_storage_variant_records_pkey PRIMARY KEY (id);


--
-- Name: activities activities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: blog_media blog_media_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blog_media
    ADD CONSTRAINT blog_media_pkey PRIMARY KEY (id);


--
-- Name: blogs blogs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blogs
    ADD CONSTRAINT blogs_pkey PRIMARY KEY (id);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: chat_groups chat_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_groups
    ADD CONSTRAINT chat_groups_pkey PRIMARY KEY (id);


--
-- Name: chat_groups_users chat_groups_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_groups_users
    ADD CONSTRAINT chat_groups_users_pkey PRIMARY KEY (id);


--
-- Name: chat_message_attachments chat_message_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_message_attachments
    ADD CONSTRAINT chat_message_attachments_pkey PRIMARY KEY (id);


--
-- Name: chat_message_receipts chat_message_receipts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_message_receipts
    ADD CONSTRAINT chat_message_receipts_pkey PRIMARY KEY (id);


--
-- Name: chat_messages chat_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_messages
    ADD CONSTRAINT chat_messages_pkey PRIMARY KEY (id);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: friend_requests friend_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.friend_requests
    ADD CONSTRAINT friend_requests_pkey PRIMARY KEY (id);


--
-- Name: friends friends_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.friends
    ADD CONSTRAINT friends_pkey PRIMARY KEY (id);


--
-- Name: images images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.images
    ADD CONSTRAINT images_pkey PRIMARY KEY (id);


--
-- Name: likes likes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.likes
    ADD CONSTRAINT likes_pkey PRIMARY KEY (id);


--
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: recipe_media recipe_media_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recipe_media
    ADD CONSTRAINT recipe_media_pkey PRIMARY KEY (id);


--
-- Name: recipes recipes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT recipes_pkey PRIMARY KEY (id);


--
-- Name: rsvps rsvps_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rsvps
    ADD CONSTRAINT rsvps_pkey PRIMARY KEY (id);


--
-- Name: user_profiles user_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT user_profiles_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: versions versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.versions
    ADD CONSTRAINT versions_pkey PRIMARY KEY (id);


--
-- Name: videos videos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.videos
    ADD CONSTRAINT videos_pkey PRIMARY KEY (id);


--
-- Name: index_action_text_rich_texts_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_action_text_rich_texts_uniqueness ON public.action_text_rich_texts USING btree (record_type, record_id, name);


--
-- Name: index_active_storage_attachments_on_blob_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_storage_attachments_on_blob_id ON public.active_storage_attachments USING btree (blob_id);


--
-- Name: index_active_storage_attachments_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON public.active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- Name: index_active_storage_blobs_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON public.active_storage_blobs USING btree (key);


--
-- Name: index_active_storage_variant_records_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_variant_records_uniqueness ON public.active_storage_variant_records USING btree (blob_id, variation_digest);


--
-- Name: index_activities_on_owner_id_and_owner_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_activities_on_owner_id_and_owner_type ON public.activities USING btree (owner_id, owner_type);


--
-- Name: index_activities_on_recipient_id_and_recipient_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_activities_on_recipient_id_and_recipient_type ON public.activities USING btree (recipient_id, recipient_type);


--
-- Name: index_activities_on_trackable_id_and_trackable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_activities_on_trackable_id_and_trackable_type ON public.activities USING btree (trackable_id, trackable_type);


--
-- Name: index_blog_media_on_attachable_type_and_attachable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_blog_media_on_attachable_type_and_attachable_id ON public.blog_media USING btree (attachable_type, attachable_id);


--
-- Name: index_blogs_on_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_blogs_on_category_id ON public.blogs USING btree (category_id);


--
-- Name: index_blogs_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_blogs_on_slug ON public.blogs USING btree (slug);


--
-- Name: index_blogs_on_tsv_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_blogs_on_tsv_name ON public.blogs USING gin (tsv_name);


--
-- Name: index_blogs_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_blogs_on_user_id ON public.blogs USING btree (user_id);


--
-- Name: index_categories_on_model; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_categories_on_model ON public.categories USING btree (model);


--
-- Name: index_categories_on_title; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_categories_on_title ON public.categories USING btree (title);


--
-- Name: index_chat_groups_users_on_chat_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_chat_groups_users_on_chat_group_id ON public.chat_groups_users USING btree (chat_group_id);


--
-- Name: index_chat_groups_users_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_chat_groups_users_on_user_id ON public.chat_groups_users USING btree (user_id);


--
-- Name: index_chat_groups_users_on_user_id_and_chat_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_chat_groups_users_on_user_id_and_chat_group_id ON public.chat_groups_users USING btree (user_id, chat_group_id);


--
-- Name: index_chat_message_attachments_on_chat_message_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_chat_message_attachments_on_chat_message_id ON public.chat_message_attachments USING btree (chat_message_id);


--
-- Name: index_chat_message_receipts_on_chat_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_chat_message_receipts_on_chat_group_id ON public.chat_message_receipts USING btree (chat_group_id);


--
-- Name: index_chat_message_receipts_on_chat_message_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_chat_message_receipts_on_chat_message_id ON public.chat_message_receipts USING btree (chat_message_id);


--
-- Name: index_chat_message_receipts_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_chat_message_receipts_on_user_id ON public.chat_message_receipts USING btree (user_id);


--
-- Name: index_chat_messages_on_chat_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_chat_messages_on_chat_group_id ON public.chat_messages USING btree (chat_group_id);


--
-- Name: index_chat_messages_on_sender_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_chat_messages_on_sender_id ON public.chat_messages USING btree (sender_id);


--
-- Name: index_comments_on_commentable_id_and_commentable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_commentable_id_and_commentable_type ON public.comments USING btree (commentable_id, commentable_type);


--
-- Name: index_comments_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_user_id ON public.comments USING btree (user_id);


--
-- Name: index_events_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_slug ON public.events USING btree (slug);


--
-- Name: index_events_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_user_id ON public.events USING btree (user_id);


--
-- Name: index_friend_requests_on_requester_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_friend_requests_on_requester_id ON public.friend_requests USING btree (requester_id);


--
-- Name: index_friend_requests_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_friend_requests_on_user_id ON public.friend_requests USING btree (user_id);


--
-- Name: index_friends_on_friend_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_friends_on_friend_id ON public.friends USING btree (friend_id);


--
-- Name: index_friends_on_friend_request_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_friends_on_friend_request_id ON public.friends USING btree (friend_request_id);


--
-- Name: index_friends_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_friends_on_user_id ON public.friends USING btree (user_id);


--
-- Name: index_images_on_attachable_type_and_attachable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_images_on_attachable_type_and_attachable_id ON public.images USING btree (attachable_type, attachable_id);


--
-- Name: index_likes_on_trackable_type_and_trackable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_likes_on_trackable_type_and_trackable_id ON public.likes USING btree (trackable_type, trackable_id);


--
-- Name: index_likes_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_likes_on_user_id ON public.likes USING btree (user_id);


--
-- Name: index_posts_on_public; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_posts_on_public ON public.posts USING btree (public);


--
-- Name: index_posts_on_tsv_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_posts_on_tsv_name ON public.posts USING gin (tsv_name);


--
-- Name: index_posts_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_posts_on_user_id ON public.posts USING btree (user_id);


--
-- Name: index_recipe_media_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_recipe_media_on_user_id ON public.recipe_media USING btree (user_id);


--
-- Name: index_recipes_on_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_recipes_on_category_id ON public.recipes USING btree (category_id);


--
-- Name: index_recipes_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_recipes_on_user_id ON public.recipes USING btree (user_id);


--
-- Name: index_rsvps_on_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_rsvps_on_event_id ON public.rsvps USING btree (event_id);


--
-- Name: index_rsvps_on_parent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_rsvps_on_parent_id ON public.rsvps USING btree (parent_id);


--
-- Name: index_user_profiles_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_profiles_on_user_id ON public.user_profiles USING btree (user_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_users_on_tsv_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_tsv_name ON public.users USING gin (tsv_name);


--
-- Name: index_versions_on_item_type_and_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_versions_on_item_type_and_item_id ON public.versions USING btree (item_type, item_id);


--
-- Name: index_videos_on_attachable_type_and_attachable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_videos_on_attachable_type_and_attachable_id ON public.videos USING btree (attachable_type, attachable_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON public.schema_migrations USING btree (version);


--
-- Name: blogs tsvectorupdate; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE ON public.blogs FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger('tsv_name', 'pg_catalog.simple', 'title');


--
-- Name: posts tsvectorupdate; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE ON public.posts FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger('tsv_name', 'pg_catalog.simple', 'body');


--
-- Name: users tsvectorupdate; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger('tsv_name', 'pg_catalog.simple', 'first_name', 'last_name');


--
-- Name: chat_message_receipts fk_rails_01f978cca9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_message_receipts
    ADD CONSTRAINT fk_rails_01f978cca9 FOREIGN KEY (chat_group_id) REFERENCES public.chat_groups(id);


--
-- Name: events fk_rails_0cb5590091; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT fk_rails_0cb5590091 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: rsvps fk_rails_115d52081c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rsvps
    ADD CONSTRAINT fk_rails_115d52081c FOREIGN KEY (event_id) REFERENCES public.events(id);


--
-- Name: recipes fk_rails_22f4e84158; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT fk_rails_22f4e84158 FOREIGN KEY (category_id) REFERENCES public.categories(id);


--
-- Name: chat_messages fk_rails_6223514182; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_messages
    ADD CONSTRAINT fk_rails_6223514182 FOREIGN KEY (sender_id) REFERENCES public.users(id);


--
-- Name: blogs fk_rails_6ffd22a5a4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blogs
    ADD CONSTRAINT fk_rails_6ffd22a5a4 FOREIGN KEY (category_id) REFERENCES public.categories(id);


--
-- Name: chat_message_receipts fk_rails_88856e0fa2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_message_receipts
    ADD CONSTRAINT fk_rails_88856e0fa2 FOREIGN KEY (chat_message_id) REFERENCES public.chat_messages(id);


--
-- Name: chat_groups_users fk_rails_97545eaf94; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_groups_users
    ADD CONSTRAINT fk_rails_97545eaf94 FOREIGN KEY (chat_group_id) REFERENCES public.chat_groups(id);


--
-- Name: chat_message_receipts fk_rails_9867c36447; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_message_receipts
    ADD CONSTRAINT fk_rails_9867c36447 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: active_storage_variant_records fk_rails_993965df05; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT fk_rails_993965df05 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: chat_messages fk_rails_a19c3bb8bc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_messages
    ADD CONSTRAINT fk_rails_a19c3bb8bc FOREIGN KEY (chat_group_id) REFERENCES public.chat_groups(id);


--
-- Name: active_storage_attachments fk_rails_c3b3935057; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT fk_rails_c3b3935057 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: chat_groups_users fk_rails_f7b37bd7d5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_groups_users
    ADD CONSTRAINT fk_rails_f7b37bd7d5 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: chat_message_attachments fk_rails_f99b81690f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_message_attachments
    ADD CONSTRAINT fk_rails_f99b81690f FOREIGN KEY (chat_message_id) REFERENCES public.chat_messages(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20160731044836'),
('20160731045808'),
('20160731050120'),
('20160731104259'),
('20160801094451'),
('20160806023746'),
('20160806141904'),
('20160807032520'),
('20160807032607'),
('20160807033320'),
('20160807051628'),
('20160807164700'),
('20160807180624'),
('20160808073114'),
('20160809074722'),
('20160811163956'),
('20160811164714'),
('20160811165102'),
('20160811165306'),
('20160811170021'),
('20160813062412'),
('20160813063008'),
('20160813063449'),
('20160813064505'),
('20160814131210'),
('20160815123614'),
('20160817004636'),
('20160817115752'),
('20160817120411'),
('20160830152057'),
('20190418065909'),
('20190823015952'),
('20200708013033'),
('20200709004904'),
('20200711153125'),
('20200815221529'),
('20201128112105'),
('20210401215608'),
('20210401220056'),
('20210401220057'),
('20210402143119'),
('20210402172548'),
('20210402172722'),
('20210402221047'),
('20210402222639'),
('20210702033618'),
('20210702033807'),
('20210702041504'),
('20221109224315'),
('20221109230404'),
('20221114151639'),
('20230426170730'),
('20230426170739'),
('20230426170757'),
('20230426171448'),
('20230522114300'),
('20230528033922'),
('20230528034231'),
('20230528034828');


