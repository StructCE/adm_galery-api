class ArtistSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :name, :biography, :birthdate, :deathdate, :birthplace, :image_url

  def image_url
    if object.picture.attached?
      rails_blob_path(object.picture, only_path: true)
    end
  end
end
