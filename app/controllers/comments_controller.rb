class CommentsController < ApplicationController
  load_and_authorize_resource

  def create
    commentable = commentable_type.constantize.find(commentable_id)
    @comment = Comment.build_from(commentable, current_user.id, body)

    respond_to do |format|
      if @comment.save
        @total_comments = commentable.comment_threads.count
        @new_comment = Comment.build_from(commentable, current_user.try(:id), nil)
        flash[:notice] = 'Comment posted!'

        template = if make_child_comment
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

  def destroy
    comment = Comment.find(params[:id])
    commentable = comment.commentable
    comment.destroy
    @total_comments = commentable.comment_threads.count
    respond_to do |format|
      flash[:alert] = 'Comment deleted!'
      format.html { redirect_to :back }
      format.json { render json: { message: 'Comment deleted!', total_comments: @total_comments } }
    end
  end

  private

  def comment_params
    permitted_params = %i(
      body commentable_id commentable_type
    )
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

    parent_comment = Comment.find comment_id
    @comment.move_to_child_of(parent_comment)
  end
end
