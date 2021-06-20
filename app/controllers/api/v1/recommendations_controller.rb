module Api
  module V1
    class RecommendationsController < ApplicationController
      # Recommendations base CRUD
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

      # Recommentdation-Painting actions
      def add_painting
        recommendation = Recommendation.find(params[:id])
        painting = Painting.find(params[:painting_id])
        join = RecommendationPainting.new(painting: painting, recommendation: recommendation)
        join.save!
        render json: join, status: :created
      rescue StandardError
        head(:bad_request)
      end

      def all_paintings
        paintings = Recommendation.find(params[:id]).paintings
        render json: paintings, status: :ok
      end

      def remove_painting
        recommendation = Recommendation.find(params[:id])
        join = recommendation.recommendation_paintings.where(painting_id: params[:painting_id])
        join.destroy_all
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
  end
end
