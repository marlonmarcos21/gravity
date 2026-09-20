# Deliberately not frozen: ActionMailer's railtie sets :open_timeout/:read_timeout
# on this hash in place (from config.action_mailer.smtp_timeout, which
# load_defaults 7.0+ enables), so freezing it raises FrozenError during boot.
# rubocop:disable Style/MutableConstant
SMTP_SETTINGS = {
  address: 'smtp.sendgrid.net',
  authentication: :plain,
  domain: 'gravity.ph',
  enable_starttls_auto: true,
  user_name: 'apikey',
  password: ENV.fetch('SENDGRID_API_KEY'),
  port: '587'
}
# rubocop:enable Style/MutableConstant
