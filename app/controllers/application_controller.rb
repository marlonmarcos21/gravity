class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include PublicActivity::StoreController

  before_action :set_paper_trail_whodunnit

  after_action :flash_to_headers

  helper_method :activities, :notification_count, :message_count, :recipe_categories

  rescue_from CanCan::AccessDenied do |exception|
    if request.xhr?
      response.headers['X-Message'] = exception.message
      response.headers['X-Message-Type'] = 'alert'
      render json: { errors: exception.message }, status: :forbidden
    else
      redirect_page = request.env['HTTP_REFERER'] || root_path
      redirect_to redirect_page, alert: exception.message
    end
  end

  def set_light_mode
    cookies.delete(:dark_mode)
    redirect_page = request.env['HTTP_REFERER'] || root_path
    redirect_to redirect_page
  end

  def set_dark_mode
    cookies.permanent[:dark_mode] = true
    redirect_page = request.env['HTTP_REFERER'] || root_path
    redirect_to redirect_page
  end

  def clear_notifications
    raise CanCan::AccessDenied.new('Unauthorized') unless current_user

    current_user
      .activities_as_recipient
      .for_notification
      .unread
      .update_all(is_read: true)

    Rails.cache.delete "user/#{current_user.id}/notification-count"
  end

  def clear_message_count
    raise CanCan::AccessDenied.new('Unauthorized') unless current_user

    Rails.cache.delete "user/#{current_user.id}/message-count"
  end

  def activities
    return Activity.none unless current_user

    current_user
      .activities_as_recipient
      .for_notification
      .descending
      .limit(10)
  end

  def notification_count
    Rails.cache.fetch("user/#{current_user.id}/notification-count") do
      count = current_user
                .activities_as_recipient
                .for_notification
                .unread
                .count

      return count if count < 10

      '9+'
    end
  end

  def message_count
    Rails.cache.fetch("user/#{current_user.id}/message-count") do
      count = current_user
                .message_receipts
                .inbox
                .unread
                .count

      return count if count < 10

      '9+'
    end
  end

  def recipe_categories
    Rails.cache.fetch('recipe-categories') do
      RecipeCategory.order(:title)
    end
  end

  protected

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end

  private

  def flash_to_headers
    return unless request.xhr?

    flash_message, flash_type = flash_message_and_type
    response.headers['X-Message'] = flash_message
    response.headers['X-Message-Type'] = flash_type.to_s
    flash.discard
  end

  def flash_message_and_type
    %i(alert notice).each do |type|
      return [flash[type], type] unless flash[type].blank?
    end
    [nil, nil]
  end
end
