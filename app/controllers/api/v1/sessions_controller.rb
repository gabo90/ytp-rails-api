module Api
  module V1
    class SessionsController < ApplicationController
      # POST /log_in
      def log_in
        user = User.find_by(email: params[:email])

        return error('Usuario no encontrado', 422) if user.nil?
        return error('Contraseña inválida', 422) unless user.authenticate(params[:password])

        payload = { user_id: user.id }
        expiration = Time.now.to_i + 1.hour.to_i

        data = {
          auth_token: AuthToken.encode(payload, expiration),
          email: user.email,
          user_name: user.full_name
        }

        response = {
          result: true,
          data: data,
          message: 'Se ha iniciado sesión correctamente'
        }

        render json: response, status: :created
      end
    end
  end
end