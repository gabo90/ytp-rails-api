class User < ApplicationRecord
  enum role: %i[admin holder]

  has_one :account

  COMPOSE = {
    except: %i[password_digest created_at updated_at],
    methods: [:clabe]
  }.freeze

  has_secure_password(validations: false)

  validates :email, format: { with: /\A[0-9a-zA-Z@._]*\z/, message: 'Formato inválido, solo se permiten caracteres alfa númericos' }
  validates_uniqueness_of :email

  before_save :compose_fields

  def full_name
    "#{first_name} #{last_name}"
  end

  def clabe
    account.present? ? account.clabe : ''
  end

  private

  def compose_fields
    self.first_name = first_name.lstrip.mb_chars.capitalize.to_s if first_name.present?
    self.last_name = last_name.lstrip.mb_chars.capitalize.to_s if last_name.present?
    self.email = email.lstrip.mb_chars.downcase.to_s if email.present?
  end
end