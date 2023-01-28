class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  respond_to :json

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
end
