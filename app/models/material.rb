class Material < ApplicationRecord
  belongs_to :recipe

  validates :name, presence: true, length: { maximum: 100 }
  validates :position, presence: true, uniqueness: { scope: :recipe_id }
end
