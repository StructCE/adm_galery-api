class Api::V1::LibrariesController < ApplicationController
  acts_as_token_authentication_handler_for User, fallback_to_devise: false
  before_action :require_login
  before_action :user_has_library?, only: %i[add_paintings remove_paintings]

  def create
    library = Library.new(user_id: current_user.id, painting_ids: params[:painting_ids])
    library.save!
    render json: library, status: :created
  rescue StandardError => e
    render json: { Error: e }, status: :unprocessable_entity
  end

  def destroy
    library = current_user.library
    library.destroy!
    head(:ok)
  rescue StandardError => e
    render json: { Error: e }, status: :unprocessable_entity
  end

  def add_paintings
    library = current_user.library
    paintings = if params[:painting_ids].is_a?(Array)
                  (library.painting_ids + params[:painting_ids]).uniq
                else
                  library.painting_ids.push(params[:painting_ids]).uniq
                end
    library.update!(painting_ids: paintings)
    render json: library, status: :ok
  rescue StandardError => e
    render json: { Error: e }, status: :unprocessable_entity
  end

  def remove_paintings
    library = current_user.library

    paintings = if params[:painting_ids].is_a?(Array)
                  library.painting_ids - params[:painting_ids]
                else
                  library.painting_ids.delete(params[:painting_ids])
                  library.painting_ids
                end
    library.update!(painting_ids: paintings)
    render json: library, status: :ok
  rescue StandardError => e
    render json: { Error: e }, status: :unprocessable_entity
  end

  def show
    if current_user.library
      library = current_user.library
      render json: library
    else
      head(:not_found)
    end
  end

  private

  def library_params
    params.require(:library).permit(:user_id, :painting_ids)
  end

  def user_has_library?
    head(:bad_request) unless current_user.library
  end
end
