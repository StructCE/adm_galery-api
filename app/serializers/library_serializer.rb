class LibrarySerializer < ActiveModel::Serializer
  attributes :id, :user_id, :painting_ids, :paintings_names

  def paintings_names
    names = []
    object.paintings.each do |p|
      names.push(p.name)
    end
    names
  end
end
