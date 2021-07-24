module Api
  module V1
    class StylesController < ApplicationController
      acts_as_token_authentication_handler_for User, only: %i[create update destroy],
                                                     fallback_to_devise: false

      before_action :require_login, :admin_permission, only: %i[create update destroy]


      def index
        styles = Style.all
        render json: styles, status: :ok
      end

      def create
        style = Style.new(style_params)
        style.save!
        render json: style, status: :created
      rescue StandardError
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
      rescue StandardError
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
  end
end
