class CartList < ApplicationRecord
  belongs_to :recipe
  belongs_to :user
  has_many :cart_items, dependent: :destroy

  validates :name, presence: true
  validates :position, presence: true, numericality: { only_integer: true }
  validates :own_notes, inclusion: { in: [true, false] }
end
