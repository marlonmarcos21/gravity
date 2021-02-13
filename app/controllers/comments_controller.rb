class CommentsController < ApplicationController
  load_and_authorize_resource

  def create
    @commentable = commentable_type.constantize.find(commentable_id)
    @comment = Comment.build_from(@commentable, current_user.id, body)

    respond_to do |format|
      if @comment.save
        CommentMailer.delay.new_comment(@comment.id) unless current_user == @commentable.user
        @commentable.create_activity :comment
        @total_comments = @commentable.comment_threads.count
        @new_comment = Comment.build_from(@commentable, current_user.try(:id))
        flash[:notice] = 'Comment posted!'

        template = if make_child_comment
                     CommentMailer.delay.reply_comment(@comment.id) unless current_user == @parent_comment.user
                     @commentable.create_activity :reply_comment, recipient: @parent_comment.user
                     :new_reply
                   else
                     :new_comment
                   end

        format.html { redirect_to :back }
        format.js { render template }
      else
        format.html { render(nothing: true) }
      end
    end
  end

  def editable
    attrs = {}
    attrs[params[:name]] = params[:value]

    respond_to do |format|
      if @comment.update(attrs)
        flash[:notice] = 'Comment updated!'
        format.json do
          render json: {
            message: 'success',
            comment_id: @comment.id,
            content: @comment.body
          }, status: :ok
        end
      else
        flash[:alert] = 'Comment update failed!'
        format.json do
          render json: { message: 'failed' },
                 status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    commentable = @comment.commentable
    @comment.destroy
    @total_comments = commentable.comment_threads.count
    element_id = "#{@comment.commentable_type.underscore}-#{@comment.commentable_id}"
    respond_to do |format|
      flash[:alert] = 'Comment deleted!'
      format.html { redirect_to :back }
      format.json do
        render json: {
          message: 'Comment deleted!',
          element_id: element_id,
          total_comments: @total_comments
        }
      end
    end
  end

  private

  def comment_params
    permitted_params = %i(body commentable_id commentable_type)
    params.require(:comment).permit(*permitted_params)
  end

  def commentable_type
    comment_params[:commentable_type]
  end

  def commentable_id
    comment_params[:commentable_id]
  end

  def comment_id
    params[:comment_id]
  end

  def body
    comment_params[:body]
  end

  def make_child_comment
    return if comment_id.blank?

    @parent_comment = Comment.find comment_id
    @comment.move_to_child_of(@parent_comment)
  end
end
