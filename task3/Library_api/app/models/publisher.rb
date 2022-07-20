class Publisher < ApplicationRecord
  has_many :books
  #accepts_nested_attributes_for :books, update_only: true, allow_destroy: true #!!!
end
