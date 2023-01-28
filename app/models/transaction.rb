class Transaction < ApplicationRecord
  validates :amount, presence: true
  validates :transaction_type, presence: true

  protokoll :invoice_number, pattern: 'WL-%Y%m###'

  enum transaction_type: {
    topup: 0,
    transfer: 1
  }
end
