class CartList < ApplicationRecord
  belongs_to :recipe, optional: true
  belongs_to :user
  has_many :cart_items, dependent: :destroy

  validates :name, presence: true, length: { maximum: 100 }
  validates :position, presence: true, numericality: { only_integer: true }
  validates :own_notes, inclusion: { in: [true, false] }
  validates :recipe_id, uniqueness: { scope: :user_id }, unless: -> { own_notes }

  validate :ensure_single_own_notes
  validate :own_notes_values

  private

  def ensure_single_own_notes
    errors.add(:own_notes, 'じぶんメモはすでに存在します') if CartList.exists?(user_id: user, own_notes: true) && own_notes
  end

  def own_notes_values
    return unless own_notes

    errors.add(:name, 'はじぶんメモにしてください') if name != 'じぶんメモ'
    errors.add(:position, 'は1にしてください') if position != 1
    errors.add(:recipe_id, 'はじぶんメモに関連づけることはできません') if recipe.present?
  end
end
