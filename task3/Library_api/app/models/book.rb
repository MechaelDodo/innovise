class Book < ApplicationRecord
  belongs_to :author
  belongs_to :publisher
  has_many :book_categories
  has_many :categories, through: :book_categories

end
