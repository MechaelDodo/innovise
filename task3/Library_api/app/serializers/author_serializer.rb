class AuthorSerializer < ActiveModel::Serializer
  attributes  :name
  has_many :books
end
