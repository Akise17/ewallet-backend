class AddExternalInfoForTrx < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :external_id, :string
    add_column :transactions, :from_id, :bigint
    add_column :transactions, :checkout_url, :json
    add_column :transactions, :status, :string, default: 'pending'
    add_column :transactions, :raw_response, :json

    change_column :transactions, :transaction_type, 'integer USING CAST(transaction_type AS integer)'
  end
end
