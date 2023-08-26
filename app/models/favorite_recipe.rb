class FavoriteRecipe < ApplicationRecord
  belongs_to :user
  belongs_to :recipe

  validates :user_id, uniqueness: { scope: :recipe_id }

  scope :created_in_last_3_days, -> { where(created_at: 3.days.ago..Time.current) }
end
