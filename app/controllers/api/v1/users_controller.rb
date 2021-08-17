module Api
  module V1
    class UsersController < ApplicationController
      acts_as_token_authentication_handler_for User, only: %i[show update destroy index logout],
                                                     fallback_to_devise: false

      before_action :require_login, only: %i[show update destroy index]
      before_action :check_if_exists, only: :show

      def create
        user = User.create(user_params)
        user.color = "#6F1D1B";
        begin
          user.save!
          library = Library.new(user_id: user.id, painting_ids: nil)
          library.save!
          render json: user, status: :created
        rescue StandardError => e
          render json: { message: e.message }, status: :unprocessable_entity
        end
      end

      def show
        user = User.find(params[:id])
        if user.confidential && user != current_user
          head(:forbidden)
        else
          render json: user, status: :ok
        end
      end

      def index
        users = User.where(confidential: false)
        render json: users, status: :ok
      end

      def destroy
        user = current_user
        begin
          user.destroy!
          render json: { message: "Usuário #{user.name} excluído com sucesso!" }, status: :ok
        rescue StandardError => e
          render json: { Erro: e }, status: :unprocessable_entity
        end
      end

      def update
        user = current_user
        begin
          user.update!(user_params)
          render json: user, status: :ok
        rescue StandardError => e
          render json: { Erro: e }, status: :unprocessable_entity
        end
      end

      def edit_image
        user = User.find(params[:id])
        begin
          if user.image.attached?
            user.image.purge
          end
          user.image.attach(params[:image])
          render json: user
        rescue StandardError => e
          render json: { message: e.message }, status: :bad_request
        end
      end

      def login
        user = User.find_by(email: params[:email])
        if user.valid_password?(params[:password])
          render json: user, status: :ok
        else
          render json: { message: 'Senha incorreta!' }, status: :unauthorized
        end
      rescue StandardError
        render json: { message: 'Email inválido!' }, status: :unauthorized
      end

      def logout
        if current_user.presence
          head(:ok)
        else
          head(:bad_request)
        end
      end

      private

      def user_params
        params.require(:user).permit(
          :name, :bio, :confidential, :email, :password, :password_confirmation, :image, :color
        )
      end

      def check_if_exists
        head(:not_found) unless User.exists?(params[:id])
      end

      # def check_privileges
      #   head(:forbidden) unless
      #     current_user.authentication_token == User.find_by(email: 'admin@admin.com').authentication_token
      # end
    end
  end
end
