class PaintingSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :name, :year, :artist_id, :style_id, :style_name,
             :description, :currentplace, :image_url, :artist_name, :style_description

  def artist_name
    object.artist.name
  end

  def style_name
    object.style.title
  end

  def style_description
    object.style.description
  end

  def image_url
    rails_blob_path(object.image, only_path: true) if object.image.attached?
  end
end
