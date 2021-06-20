class Api::V1::RecommendationsController < ApplicationController
  def index
    recommendations = Recommendation.all
    render json: recommendations, status: :ok
  end

  def create
    recommendation = Recommendation.new(recommendation_params)
    recommendation.save!
    render json: recommendation, status: :created
  rescue StandardError
    head(:bad_request)
  end

  def show
    recommendation = Recommendation.find(params[:id])
    render json: recommendation, status: :ok
  end

  def update
    recommendation = Recommendation.find(params[:id])
    recommendation.update!(recommendation_params)
    render json: recommendation, status: :ok
  rescue StandardError
    head(:bad_request)
  end

  def destroy
    recommendation = Recommendation.find(params[:id])
    recommendation.destroy
    head(:no_content)
  end

  private

  def recommendation_params
    params.require(:recommendation).permit(
      :title,
      :description
    )
  end
end
