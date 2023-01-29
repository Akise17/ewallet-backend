class AddStateHistory < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :transfer_to, :string
    add_column :transactions, :state_history, :json

    add_index :transactions, :transfer_to
  end
end
