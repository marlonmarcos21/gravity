class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :in_homepage?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  def in_homepage?
    request.original_fullpath == '/'
  end

  protected

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end
end
