class Api::V1::ArtistsController < ApplicationController
  def index
    artists = Artist.all
    render json: artists, status: :ok
  end

  def show
    artist = Artist.find(params[:id])
    render json: artist, status: :ok
  rescue StandardError => e
    head(:not_found)
  end
  
  def create
    artist = Artist.new(artist_params)
    artist.save!
    render json: artist, status: :created
  rescue StandardError => e
    head(:unprocessable_entity)
  end

  def update
    artist = Artist.find(params[:id])
    artist.update!(artist_params)
    render json: artist, status: :ok
  rescue StandardError => e
    head(:unprocessable_entity)
  end

  def destroy
    artist = Artist.find(params[:id])
    artist.destroy!
    head(:ok)
  rescue StandardError => e
    head(:not_found)
  end

  private
  def artist_params
    params.require(:artist).permit(:name, :biography, :birthdate, :deathdate, :birthplace)
  end
end
