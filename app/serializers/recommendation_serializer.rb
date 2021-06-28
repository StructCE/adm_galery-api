class RecommendationSerializer < ActiveModel::Serializer
  attributes :id, :title, :description

  has_many :paintings, through: :recommendation_paintings
end
