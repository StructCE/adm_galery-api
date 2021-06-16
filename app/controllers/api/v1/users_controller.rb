class Api::V1::UsersController < ApplicationController
  acts_as_token_authentication_handler_for User, only: %i[show update destroy index]

  before_action :check_if_exists, only: :show

  def create
    user = User.new(user_params)
    begin
      user.save!
      render json: user, status: :created
    rescue StandardError => e
      render json: { Erro: e }, status: :unprocessable_entity
    end
  end

  def show
    user = User.find(params[:id])
    render json: user, status: :ok
  end

  def index
    users = User.all
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

  def sign_in
    user = User.find_by(email: params[:email])
    if user.valid_password?(params[:password])
      render json: user, status: :ok
    else
      render json: { message: 'Senha incorreta!' }, status: :unauthorized
    end
  rescue StandardError
    render json: { message: 'Email inválido!' }, status: :unauthorized
  end

  private

  def user_params
    params.require(:user).permit(
      :name, :bio, :confidential, :email, :password, :password_confirmation, :image
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
