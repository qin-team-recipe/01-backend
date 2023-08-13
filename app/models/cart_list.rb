class CartList < ApplicationRecord
  belongs_to :recipe
  belongs_to :user
  has_many :cart_items, dependent: :destroy
end
