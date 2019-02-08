class Account < ApplicationRecord
  enum type: [:current]

  belongs_to :user
  has_many :account_transactions
end
