class PasswordsController < Devise::PasswordsController
  def new
    redirect_page = request.env['HTTP_REFERER'].nil? ? root_url : :back
    redirect_to redirect_page
  end

  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    redirect_page = request.env['HTTP_REFERER'].nil? ? root_url : :back
    if successfully_sent?(resource)
      redirect_to redirect_page, notice: 'Email sent, please check and follow instructions provided'
    else
      redirect_to redirect_page, alert: 'Email does not exist'
    end
  end

  def edit
    super
  end
end
