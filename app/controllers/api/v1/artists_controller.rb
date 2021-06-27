module Api
  module V1
    class ArtistsController < ApplicationController
      acts_as_token_authentication_handler_for User, only: %i[create update destroy],
                                                     fallback_to_devise: false

      before_action :require_login, :admin_permission, only: %i[create update destroy]

      def index
        artists = Artist.all
        render json: artists, status: :ok
      end

      def show
        artist = Artist.find(params[:id])
        render json: artist, status: :ok
      rescue StandardError
        head(:not_found)
      end

      def create
        artist = Artist.new(artist_params)
        artist.save!
        render json: artist, status: :created
      rescue StandardError
        head(:unprocessable_entity)
      end

      def update
        artist = Artist.find(params[:id])
        artist.update!(artist_params)
        render json: artist, status: :ok
      rescue StandardError
        head(:unprocessable_entity)
      end

      def destroy
        artist = Artist.find(params[:id])
        artist.destroy!
        head(:ok)
      rescue StandardError
        head(:not_found)
      end

      private

      def artist_params
        params.require(:artist).permit(:name, :biography, :birthdate, :deathdate, :birthplace,
                                       :picture)
      end
    end
  end
end
