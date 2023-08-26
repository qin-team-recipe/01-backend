class Recipe < ApplicationRecord
  has_many :favorite_recipes, dependent: :destroy
  has_many :favoriters, through: :favorite_recipes, source: :user
  belongs_to :user
  has_many :steps, dependent: :destroy
  has_many :materials, dependent: :destroy
  has_one :cart_list, dependent: :destroy
  has_many :recipe_external_links, dependent: :destroy

  validates :name, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 256 }
  validates :serving_size, presence: true
  validates :is_draft, inclusion: { in: [true, false] }
  validates :is_public, inclusion: { in: [true, false] }
end
