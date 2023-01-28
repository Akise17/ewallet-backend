class Team < ApplicationRecord
  validates :phone_number, presence: true
  has_one_time_password column_name: :otp_secret_key, length: 4, interval: 300

  devise :database_authenticatable,
         :jwt_authenticatable,
         :registerable, :recoverable, :rememberable, :validatable, :confirmable,
         jwt_revocation_strategy: TeamJwtDenylist

  before_validation :set_user

  def set_user
    self.email = "#{phone_number}@mail.com"
    self.password = phone_number
  end
end
