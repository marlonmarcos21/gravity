require 'redirect_outgoing_mails'
ActionMailer::Base.register_interceptor(RedirectOutgoingMails) unless Rails.env == 'production'
