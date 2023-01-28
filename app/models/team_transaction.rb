class TeamTransaction < Transaction
  has_many :transactions, class_name: 'TeamTransaction', foreign_key: 'owner_id'
end
