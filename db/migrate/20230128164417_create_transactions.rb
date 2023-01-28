class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.string :transaction_type
      t.string :invoice_number
      t.decimal :amount
      t.string :type
      t.bigint :owner_id
      t.timestamps
    end
  end
end
