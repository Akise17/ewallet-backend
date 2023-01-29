class Transaction < ApplicationRecord
  validates :amount, presence: true
  validates :transaction_type, presence: true

  belongs_to :transfer_from, class_name: 'Transaction', foreign_key: 'from_id', optional: true

  protokoll :invoice_number, pattern: 'WL-%Y%m###'

  enum transaction_type: {
    topup: 0,
    transfer: 1,
    receive: 2
  }

  scope :settle, -> { where(status: 'settlement') }

  state_machine :status, initial: :pending do
    event :completed do
      transition to: :settlement, from: :pending
      transition to: :settlement, from: :on_progress
    end
    event(:failed) { transition to: :failed, from: :pending }
    event(:cancelled) { transition to: :cancelled, from: :pending }
    event(:process) { transition to: :on_progress, from: :pending }

    before_transition do |trx, transition|
      trx.log_status_change(transition)
    end

    after_transition pending: :on_progress, do: :after_on_progress_callback
    after_transition any => :settlement, do: :after_completed_callback
  end

  before_create :update_amount
  after_create :process_transaction

  def process_transaction
    case transaction_type
    when 'topup', 'receive'
      completed
    when 'transfer'
      process
    end
  end

  def update_amount
    return unless transfer? || receive?

    self.amount *= -1
  end

  def log_status_change(transition)
    self.state_history ||= []

    self.state_history.push({ from: transition.from,
                              to: transition.to,
                              event: transition.event,
                              at: Time.zone.now })
  end

  def self.balance
    return 0 if blank?

    settle.sum(:amount)
  end

  def after_on_progress_callback
    trx = recepient.transactions.new(amount:, transaction_type: 'receive', from_id: id)
    trx.save!
  end

  def after_completed_callback
    return unless receive?

    transfer_from.completed
  end
end
