SMTP_SETTINGS = {
  address: 'smtp.sendgrid.net',
  authentication: :plain,
  domain: 'gravity.ph',
  enable_starttls_auto: true,
  user_name: 'apikey',
  password: ENV.fetch('SENDGRID_API_KEY'),
  port: '587'
}.freeze
