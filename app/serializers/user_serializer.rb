class UserSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :name, :email, :bio, :image_url, :authentication_token

  def image_url
    if object.image.attached?
      rails_blob_path(object.image, only_path: true)
    else
      'Usuário sem imagem!'
    end
  end
end
