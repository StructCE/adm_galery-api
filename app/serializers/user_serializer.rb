class UserSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :name, :email, :bio, :image_url, :authentication_token, :confidential

  def image_url
    if object.image.attached?
      rails_blob_path(object.image, only_path: true)
    end
  end
end
