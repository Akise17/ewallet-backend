class UserTransaction < Transaction
  has_one :recepient, class_name: 'User', foreign_key: 'phone_number', primary_key: 'transfer_to'
end
