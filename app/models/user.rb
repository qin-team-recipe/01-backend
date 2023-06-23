class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :recipes, as: :author
  has_many :favorite_chefs
  has_many :chefs, through: :favorite_chefs
  has_many :favorite_recipes
  has_many :cart_lists
end
