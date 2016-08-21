class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include PublicActivity::StoreController

  after_action :flash_to_headers

  helper_method :in_homepage?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to :back, alert: exception.message
  end

  def in_homepage?
    request.original_fullpath == '/'
  end

  protected

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end

  private

  def flash_to_headers
    return unless request.xhr?
    response.headers['X-Message'] = flash_message
    response.headers['X-Message-Type'] = flash_type.to_s
    flash.discard 
  end

 def flash_message
    %i(alert notice).each do |type|
      return flash[type] unless flash[type].blank?
    end
    nil
  end

  def flash_type
    %i(alert notice).each do |type|
      return type unless flash[type].blank?
    end
    nil
  end
end
