class ArtistSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :name, :biography, :birthdate, :deathdate, :birthplace, :image_url

  def birthdate
    if object.birthdate
      I18n.l(object.birthdate, format: :long, locale: :'pt')
    else
      nil
    end
  end

  def deathdate
    if object.deathdate
      I18n.l(object.deathdate, format: :long, locale: :'pt')
    else
      nil
    end
  end

  def image_url
    if object.picture.attached?
      rails_blob_path(object.picture, only_path: true)
    end
  end
end
