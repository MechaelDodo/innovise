class CategorySerializer < ActiveModel::Serializer
  attributes :name
  has_many :books, through: :book_categories
end
