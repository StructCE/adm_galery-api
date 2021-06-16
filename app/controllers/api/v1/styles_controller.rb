class Api::V1::StylesController < ApplicationController
  def index
    styles = Style.all
    render json: styles, status: :ok
  end

  def create
    style = Style.new(style_params)
    style.save!
    render json: style, status: :created
    rescue StandardError => e
      head(:bad_request)
  end

  def show
    style = Style.find(params[:id])
    render json: style, status: :ok
  end

  def update
    style = Style.find(params[:id])
    style.update!(style_params)
    render json: style, status: :ok
    rescue StandardError => e
      head(:bad_request)
  end

  def destroy
    style = Style.find(params[:id])
    style.destroy
    head(:no_content)
  end

  private
  def style_params
    params.require(:style).permit(
      :title,
      :description
    )
  end
end
