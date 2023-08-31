class CartList < ApplicationRecord
  belongs_to :recipe, optional: true
  belongs_to :user
  has_many :cart_items, dependent: :destroy

  validates :name, presence: true, length: { maximum: 100 }
  validates :position, presence: true, numericality: { only_integer: true }
  validates :own_notes, inclusion: { in: [true, false] }
  validates :recipe_id, uniqueness: { scope: :user_id }, unless: -> { own_notes }

  validate :ensure_single_own_notes

  private

  def ensure_single_own_notes
    errors.add(:own_notes, 'じぶんメモはすでに存在します') if CartList.exists?(user_id: user, own_notes: true) && own_notes
  end
end
