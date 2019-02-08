class User < ApplicationRecord
  enum role: [:admin, :holder]

  has_many :accounts
end
