class CommentMailerPreview < ActionMailer::Preview
  def new_comment
    CommentMailer.new_comment(comment)
  end

  def reply_comment
    CommentMailer.reply_comment(comment_reply)
  end

  private

  def comment
    Comment.last
  end

  def comment_reply
    Comment.where.not(parent_id: nil).last
  end
end
