module Api
  module V1
    class TransfersController < ApplicationController
      before_action :authenticate_request!
      before_action :set_account

      # POST /transfers
      def create
        authorize! :create, AccountTransaction
        @msg = ''
        @error = false

        ActiveRecord::Base.transaction do
          return error('Cuenta no encontrada', 422) unless @destination_account.present?
          return error('No se especificó un monto', 422) unless params[:amount].present?
          origin_account = @current_user.account
          same_account = @destination_account.id == origin_account.id
          return error('La cuenta de destino es la misma cuenta de origen', 422) if same_account

          amount = params[:amount].to_f
          return error('Monto inválido', 422) if amount <= 0.0

          return error('Fondos insuficientes', 422) if origin_account.balance < amount

          origin_account.balance -= amount

          unless origin_account.save
            @error = true
            @msg = origin_account.errors.try { full_messages.join(', ') }
            raise ActiveRecord::Rollback
          end

          transaction = origin_account
                        .account_transactions
                        .new(transaction_type: 'out', amount: amount)

          unless transaction.save
            @error = true
            @msg = transaction.errors.try { full_messages.join(', ') }
            raise ActiveRecord::Rollback
          end

          @destination_account.balance += amount

          unless @destination_account.save
            @error = true
            @msg = @destination_account.errors.try { full_messages.join(', ') }
            raise ActiveRecord::Rollback
          end

          transaction = @destination_account
                        .account_transactions
                        .new(amount: amount)

          unless transaction.save
            @error = true
            @msg = transaction.errors.try { full_messages.join(', ') }
            raise ActiveRecord::Rollback
          end

          render json: { result: true, message: 'Transferencia realizada correctamente' }
        end

        error(@msg, 422) if @error
      end

      # POST /transfers/deposit
      def deposit
        authorize! :deposit, AccountTransaction
        @msg = ''
        @error = false

        ActiveRecord::Base.transaction do
          return error('Cuenta no encontrada', 422) unless @destination_account.present?
          return error('No se especificó un monto', 422) unless params[:amount].present?

          amount = params[:amount].to_f
          return error('Monto inválido', 422) if amount <= 0.0

          @destination_account.balance += amount

          unless @destination_account.save
            @error = true
            @msg = @destination_account.errors.try { full_messages.join(', ') }
            raise ActiveRecord::Rollback
          end

          transaction = @destination_account
                        .account_transactions
                        .new(amount: amount)

          unless transaction.save
            @error = true
            @msg = transaction.errors.try { full_messages.join(', ') }
            raise ActiveRecord::Rollback
          end

          render json: { result: true, message: 'Desposito realizado correctamente' }
        end

        error(@msg, 422) if @error
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_account
        @destination_account = Account.find_by(clabe: params[:destination])
      end
    end
  end
end
