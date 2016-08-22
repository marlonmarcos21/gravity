class UserMailer < ApplicationMailer
  def send_friend_request(user, requester)
    @user = user
    @requester = requester

    mail to: @user.email,
         subject: "#{@requester.first_name.titleize} sent you friend request"
  end

  def accept_friend_request(user, requester)
    @user = user
    @requester = requester

    mail to: @requester.email,
         subject: "#{@user.first_name.titleize} accepted your friend request"
  end
end
