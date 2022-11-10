class Api::V1::TestController < Api::ApiController
  def index
    render json: { message: 'hello world!', data: current_user }
  end
end
