class CartItem < ApplicationRecord
  belongs_to :cart_list

  validates :name, presence: true
  validates :is_checked, inclusion: { in: [true, false] }
  validates :position, presence: true, numericality: { only_integer: true }
end
