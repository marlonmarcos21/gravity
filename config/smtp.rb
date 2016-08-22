SMTP_SETTINGS = {
  address: 'smtp.sendgrid.net',
  authentication: :plain,
  domain: 'gravity.ph',
  enable_starttls_auto: true,
  user_name: ENV.fetch('SENDGRID_USERNAME'),
  password: ENV.fetch('SENDGRID_PASSWORD'),
  port: '587'
}
