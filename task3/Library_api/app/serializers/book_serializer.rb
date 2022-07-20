class BookSerializer < ActiveModel::Serializer
  attributes :id, :name, :price
  belongs_to :author, serializer: AuthorSerializer
  belongs_to :publisher, serializer: PublisherSerializer
  #has_many :book_categories
  has_many :categories, through: :book_categories
end
