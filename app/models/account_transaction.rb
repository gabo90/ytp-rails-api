class AccountTransaction < ApplicationRecord
  belongs_to :account

  enum transaction_type: %i[in out]
end