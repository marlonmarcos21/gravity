class SessionsController < Devise::SessionsController
  def new
    redirect_to :back, alert: flash.instance_variable_get('@flashes')['alert']
  end
end
