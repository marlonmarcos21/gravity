class CommentMailer < ApplicationMailer
  def new_comment(comment_id)
    @comment = Comment.includes(:commentable, :user).find comment_id
    @commentable = @comment.commentable
    @owner = @commentable.user
    @commenter = @comment.user

    mail to: @owner.email,
         subject: "#{@commenter.first_name.titleize} commented on your #{@comment.commentable_type}"
  end

  def reply_comment(comment_id)
    @comment = Comment.includes(:commentable, :parent, :user).find comment_id
    @commentable = @comment.commentable
    @parent_comment = @comment.parent
    @commenter = @comment.user

    mail to: @parent_comment.user.email,
         subject: "#{@commenter.first_name.titleize} replied to your comment"
  end
end
