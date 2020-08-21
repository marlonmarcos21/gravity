class Comment < ApplicationRecord
  include AsLikeable

  acts_as_nested_set scope: [:commentable_id, :commentable_type]

  validates :body, presence: true
  validates :user, presence: true

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  # acts_as_votable

  belongs_to :commentable, polymorphic: true, touch: true
  belongs_to :user

  has_paper_trail on: :update, only: :body

  # Helper class method to lookup all comments assigned
  # to all commentable types for a given user.
  scope :find_comments_by_user, lambda { |user|
    where(user_id: user.id).order('created_at DESC')
  }

  # Helper class method to look up all comments for
  # commentable class name and commentable id.
  scope :find_comments_for_commentable, lambda { |commentable_str, commentable_id|
    where(commentable_type: commentable_str.to_s, commentable_id: commentable_id).order('created_at DESC')
  }

  class << self
    # Helper class method that allows you to build a comment
    # by passing a commentable object, a user_id, and comment text
    # example in readme
    def build_from(obj, user_id, comment = nil)
      new \
        commentable: obj,
        user_id: user_id,
        body: comment
    end

    # Helper class method to look up a commentable object
    # given the commentable class name and id
    def find_commentable(commentable_str, commentable_id)
      commentable_str.constantize.find(commentable_id)
    end
  end

  # helper method to check if a comment has children
  def has_children?
    children.any?
  end
end
