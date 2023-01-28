class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  respond_to :json

  Unauthorized = Class.new(StandardError)

  rescue_from ActiveRecord::RecordNotFound do |e|
    data = {}
    if e.present?
      data[:status] = '404'
      data[:title] = 'Not Found'
      data[:detail] = 'Record not Found'
      data[:code] = 'record_not_found'
    end
    render json: data, status: :not_found
  end

  rescue_from Unauthorized do |e|
    data = {}
    if e.present?
      data[:status] = '401'
      data[:title] = 'Not Authorized'
      data[:detail] = 'You need to login to continue'
      data[:code] = 'not_authorized'
    end
    render json: data, status: :unprocessable_entity
  end
end
