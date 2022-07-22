class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :books, through: :book_categories
end
