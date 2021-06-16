class Api::V1::StylesController < ApplicationController
  def index
    styles = Style.all
    render json: styles
  end

  def create
    style = Style.new(style_params)
    style.save!
    render json: style
    head(:created)
    rescue StandardError => e
      head(:unprocessable_entity)
  end

  def show
    style = Style.find(params[:id])
    render json: style
  end

  def update
    style = Style.find(params[:id])
    style.update!(style_params)
    render json: style
    rescue StandardError => e
      head(:unprocessable_entity)
  end

  def destroy
    style = Style.find(params[:id])
    style.destroy
    head(:no_content)
    rescue StandardError => e
      head(:forbidden)
  end

  private
  def style_params
    params.require(:style).permit(
      :title,
      :description
    )
  end
end
