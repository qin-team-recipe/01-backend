class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :recipes, as: :author, dependent: :destroy
  has_many :favorite_chefs, dependent: :destroy
  has_many :chefs, through: :favorite_chefs
  has_many :favorite_recipes, dependent: :destroy
  has_many :cart_lists, dependent: :destroy
end
