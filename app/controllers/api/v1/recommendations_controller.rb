module Api
  module V1
    class RecommendationsController < ApplicationController
      acts_as_token_authentication_handler_for User, except: %i[index show all_paintings],
                                                     fallback_to_devise: false

      before_action :require_login, :admin_permission, except: %i[index show all_paintings]

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
        joins = []
        ids = Array(params[:painting_id]).uniq
        ids.each do |id|
          painting = Painting.find(id)
          join = RecommendationPainting.new(painting: painting, recommendation: recommendation)
          join.save!
          joins << join
        end
        render json: joins, status: :created
      rescue StandardError
        head(:bad_request)
      end

      def all_paintings
        paintings = Recommendation.find(params[:id]).paintings
        render json: paintings, status: :ok
      end

      def remove_painting
        recommendation = Recommendation.find(params[:id])
        ids = Array(params[:painting_id]).uniq
        ids.each do |id|
          join = recommendation.recommendation_paintings.where(painting_id: params[:painting_id])
          join.destroy_all
        end
        head(:no_content)
        rescue StandardError
          head(:bad_request)
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
