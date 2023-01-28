class Api::ApiController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :authenticate_api_person!
  attr_accessor :current_api_user

  def authenticate_api_person!
    @current_api_user = if current_user.present?
      authenticate_user!
    elsif current_team.present?
      authenticate_team!
    else
      raise Unauthorized
    end
  end
end
