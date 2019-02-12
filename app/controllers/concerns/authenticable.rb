module Authenticable
  extend ActiveSupport::Concern

  included do
    attr_reader :current_user
  end

  protected

  def authenticate_request!
    payload = decoded_token
    return error('No Autenticado', 401) unless payload.present?

    @current_user = User.find_by(id: payload[:user_id])
    return error('No existe el usuario', 401) unless @current_user.present?
  rescue JWT::ExpiredSignature
    return error('Sesión Expirada', 419)
  rescue JWT::VerificationError, JWT::DecodeError
    return error('No Autenticado', 401)
  rescue StandardError => e
    e.backtrace.each{ |line| p line }
    return error('Error interno')
  end

  private

  def decoded_token
    auth_header = request.headers['Authorization'].try { split(' ') } || []
    return nil unless auth_header[0] == 'JWT'

    token = auth_header[1]
    AuthToken.decode(token)
  end

  def forbidden_resource
    error('No Autorizado', 403)
  end

  def error(msg, code = 500)
    @current_user = nil
    response = { error: true, description: msg }
    render json: response, status: code
  end
end