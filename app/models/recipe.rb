class Recipe < ApplicationRecord
  has_many :favorite_recipes, dependent: :destroy
  has_many :favoriters, through: :favorite_recipes, source: :user
  belongs_to :user
  has_many :steps, dependent: :destroy
  has_many :materials, dependent: :destroy
  has_one :cart_list, dependent: :destroy
  has_many :recipe_external_links, dependent: :destroy
end
