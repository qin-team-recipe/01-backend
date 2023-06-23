class Recipe < ApplicationRecord
  belongs_to :author, polymorphic: true
  has_many :favorite_recipes
  has_many :users, through: :favorite_recipes
  has_many :steps
  has_many :materials
  has_many :cart_lists
end
