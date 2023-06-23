class Chef < ApplicationRecord
  has_many :recipes, as: :author, dependent: :destroy
  has_many :favorite_chefs, dependent: :destroy
  has_many :users, through: :favorite_chefs
  has_many :external_links, dependent: :destroy
end
