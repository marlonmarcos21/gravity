class SessionsController < Devise::SessionsController
  def new
    redirect_page = request.env['HTTP_REFERER'].nil? ? root_url : :back
    redirect_to redirect_page, alert: flash.instance_variable_get('@flashes')['alert']
  end
end
