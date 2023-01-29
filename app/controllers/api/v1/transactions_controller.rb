class Api::V1::TransactionsController < Api::ApiController
  before_action :check_balance, only: %i[create]
  def create
    ActiveRecord::Base.transaction do
      transaction = data_scope.new(transaction_params)
      return render json: { message: transaction.errors }, status: 422 unless transaction.save
      render json: transaction 
    end
  end

  def balance
    render json: { balance: data_scope.balance }
  end

  private

  def check_balance
    return unless transaction_params[:transaction_type] == 'transfer'

    raise InsufficientBalance if data_scope.balance < transaction_params[:amount]
  end

  def data_scope
    current_api_user.transactions
  end

  def transaction_params
    params.require(:transaction)
          .permit(:amount, :transaction_type, :transfer_to)
  end
end
