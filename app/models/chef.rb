class Chef < ApplicationRecord
  has_many :recipes, as: :author
  has_many :favorite_chefs
  has_many :users, through: :favorite_chefs
  has_many :external_links
end
