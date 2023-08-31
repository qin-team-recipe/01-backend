class CartList < ApplicationRecord
  belongs_to :recipe, optional: true
  belongs_to :user
  has_many :cart_items, dependent: :destroy

  validates :name, presence: true, length: { maximum: 100 }
  validates :position, presence: true, numericality: { only_integer: true }
  validates :own_notes, inclusion: { in: [true, false] }
  validates :recipe_id, uniqueness: { scope: :user_id }
end
