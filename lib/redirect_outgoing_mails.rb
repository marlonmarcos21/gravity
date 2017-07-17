class RedirectOutgoingMails
  class << self
    def delivering_email(mail)
      mail.to = ENV['INTERCEPT_RECIPIENT']
      mail.subject = '[DEV] ' + mail.subject
    end
  end
end
