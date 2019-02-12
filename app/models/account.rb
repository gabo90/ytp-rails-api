class Account < ApplicationRecord
  enum type: [:current]

  belongs_to :user
  has_many :account_transactions

  validates_presence_of :clabe, on: :create
  validates_uniqueness_of :clabe
end
