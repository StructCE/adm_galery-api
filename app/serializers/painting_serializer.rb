class PaintingSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :name, :year, :artist_id, :style_id, :description, :currentplace, :image_url

  def image_url
    if object.image.attached?
      rails_blob_path(object.image, only_path: true)
    end
  end
end
