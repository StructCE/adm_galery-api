class UserSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :name, :email, :bio, :image_url, :admin, :authentication_token, :confidential, :library

  has_one :library, serializer: LibrarySerializer

  def image_url
    if object.image.attached?
      rails_blob_path(object.image, only_path: true)
    end
  end
end
