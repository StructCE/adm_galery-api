class LibrarySerializer < ActiveModel::Serializer
  attributes :id, :user_id, :painting_ids, :paintings_names

  has_many :paintings, through: :library_paintings

  def paintings_names
    names = []
    object.paintings.each do |p|
      names.push(p.name)
    end
    names
  end
end
