module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_request!
      before_action :set_user, only: %i[show update]

      # GET /users
      def index
        authorize! :index, User
        users = User.all
        data = users.map { |user| user.as_json(User::COMPOSE) }

        render json: { result: true, data: data }, status: :ok
      end

      # GET /users/1
      def show
        authorize! :read, User
        render json: { result: true, data: @user.as_json(User::COMPOSE) }, status: :ok
      end

      # POST /users
      def create
        authorize! :create, User
        @error = false
        @msg = ''
        ActiveRecord::Base.transaction do
          user = User.new(user_params)
          if !user.save && user.errors.any?
            @msg = user.errors.try { full_messages.join(', ') }
            @error = true
            raise ActiveRecord::Rollback
          end

          account = Account.new(user: user)
          account.clabe = Array.new(10).map { rand(0..9) }.join until account.valid?
          if !account.save && account.errors.any?
            @msg = account.errors.try { full_messages.join(', ') }
            @error = true
            raise ActiveRecord::Rollback
          end

          response = {
            result: true,
            data: user.as_json(User::COMPOSE),
            message: 'Usuario registrado correctamente'
          }

          render json: response, status: :created
        end
        error(@msg, 422) if @error
      end

      # PATCH/PUT /users/1
      def update
        authorize! :update, User
        if @user.update(user_params)
          response = {
            result: true,
            data: user.as_json(User::COMPOSE),
            message: 'Usuario actualizado correctamente'
          }

          render json: response, status: :ok
        else
          msg = @user.errors.full_messages.join(' ,')
          error(msg, 422)
        end
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_user
        @user = User.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def user_params
        params.require(:user).permit(:email, :password, :role, :first_name, :last_name)
      end
    end
  end
end
