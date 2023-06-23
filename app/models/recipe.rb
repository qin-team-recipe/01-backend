class Recipe < ApplicationRecord
  belongs_to :author, polymorphic: true, dependent: :destroy
  has_many :favorite_recipes, dependent: :destroy
  has_many :users, through: :favorite_recipes
  has_many :steps, dependent: :destroy
  has_many :materials, dependent: :destroy
  has_many :cart_lists, dependent: :destroy
end
