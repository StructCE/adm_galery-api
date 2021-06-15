class Api::V1::UsersController < ApplicationController
  before_action :check_if_exists, only: %i[show update destroy]

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
    user = User.find(params[:id])
    begin
      user.destroy!
      render json: { message: "Usuário #{user.name} excluído com sucesso!" }, status: :ok
    rescue StandardError => e
      render json: { Erro: e }, status: :unprocessable_entity
    end
  end

  def update
    user = User.find(params[:id])
    begin
      user.update!(user_params)
      render json: user, status: :ok
    rescue StandardError => e
      render json: { Erro: e }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :name, :bio, :email, :password, :password_confirmation
    )
  end

  def check_if_exists
    head(:not_found) unless User.exists?(params[:id])
  end
end
