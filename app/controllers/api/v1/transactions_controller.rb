class Api::V1::TransactionsController < Api::ApiController
  def create
    transaction = current_api_user.transactions.new(transaction_params)
    return render json: transaction if transaction.save

    render json: { message: transaction.errors }
  end

  private

  def transaction_params
    params.require(:transaction)
          .permit(:amount, :transaction_type, :transfer_to)
  end
end
