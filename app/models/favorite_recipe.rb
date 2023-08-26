class FavoriteRecipe < ApplicationRecord
  belongs_to :user
  belongs_to :recipe

  validates :user_id, uniqueness: { scope: :recipe_id, message: "このレシピはすでにお気に入り登録されています" }
end
