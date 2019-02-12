class AuthToken
  # encode payload and generate JWT Token
  def self.encode(payload, exp = Time.now.to_i + (60 * 5))
    payload[:exp] = exp
    key_base = Rails.application.credentials.secret_key_base
    encode_algorithm = Rails.application.credentials.encode_algorithm
    JWT.encode(payload, key_base, encode_algorithm)
  end

  # decode and get payload from JWT Token
  def self.decode(token)
    key_base = Rails.application.credentials.secret_key_base
    encode_algorithm = Rails.application.credentials.encode_algorithm
    decoded = JWT.decode(token, key_base, true, algorithm: encode_algorithm)
    HashWithIndifferentAccess.new(decoded[0])
  end
end