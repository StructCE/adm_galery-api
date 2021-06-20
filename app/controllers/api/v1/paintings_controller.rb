class Api::V1::PaintingsController < ApplicationController
    def index
        paintings = Painting.all
        render json: paintings, status: :ok
      end

      def show
        painting = Painting.find(params[:id])
        render json: painting, status: :ok
      rescue StandardError
        head(:not_found)
      end

      def create
        painting = Painting.new(painting_params)
        painting.save!
        render json: painting, status: :created
      rescue StandardError
        head(:unprocessable_entity)
      end

      def update
        painting = Painting.find(params[:id])
        painting.update!(painting_params)
        render json: painting, status: :ok
      rescue StandardError
        head(:unprocessable_entity)
      end

      def destroy
        painting = Painting.find(params[:id])
        painting.destroy!
        head(:ok)
      rescue StandardError
        head(:not_found)
      end

      private

      def painting_params
        params.require(:painting).permit(:name, :year, :artist_id, :style_id, :description, :currentplace, :image)
      end
end