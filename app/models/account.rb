class Account < ApplicationRecord
  enum type: [:current]

  belongs_to :user
end
