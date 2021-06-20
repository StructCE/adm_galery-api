class PaintingSerializer < ActiveModel::Serializer
  attributes :id, :name, :year, :artist_id, :style_id, :description, :currentplace
end
