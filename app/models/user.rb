class User < ApplicationRecord
  enum role: [:admin, :holder]
end
