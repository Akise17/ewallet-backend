class Api::V1::Users::SessionsController < Devise::SessionsController
  respond_to :json
  attr_reader :resource

  def create
    @resource = User.find_by_phone_number!(login_params[:phone_number])
    return log_in_error unless @resource.confirm_by_token(login_params[:otp])

    log_in_success
  end

  private

  def log_in_success
    sign_in(:user, resource)
    render json: resource
  end

  def log_in_error
    render json: { message: 'Phone number or OTP error' }, status: :unprocessable_entity
  end

  def respond_to_on_destroy
    current_user ? log_out_success : log_out_failure
  end

  def log_out_success
    render json: { message: 'Logged out.' }, status: :ok
  end

  def log_out_failure
    render json: { message: 'Logged out failure.' }, status: :unauthorized
  end

  def login_params
    params.require(:user)
          .permit(:email,
                  :phone_number,
                  :otp)
  end
end
