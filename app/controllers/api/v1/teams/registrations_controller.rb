class Api::V1::Teams::RegistrationsController < Devise::RegistrationsController
  respond_to :json
  attr_reader :resource

  def create
    @resource = Team.find_or_initialize_by(phone_number: sign_up_params[:phone_number])
    return register_failed unless @resource.save

    @resource.send_confirmation_instructions
    register_success
  end

  private

  def respond_with(resource, _opts = {})
    resource.persisted? ? register_success : register_failed
  end

  def register_success
    render json: { message: 'Signed up.', data: resource }
  end

  def register_failed
    render json: { message: resource.errors }
  end

  def sign_up_params
    params.require(:user)
          .permit(:email,
                  :phone_number,
                  :password)
  end
end
