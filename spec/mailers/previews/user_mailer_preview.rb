class UserMailerPreview < ActionMailer::Preview
  def send_friend_request
    UserMailer.send_friend_request(user, requester)
  end

  def accept_friend_request
    UserMailer.accept_friend_request(user, requester)
  end

  private

  def user
    User.first
  end

  def requester
    User.last
  end
end
