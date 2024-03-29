class Recipe < ApplicationRecord
  PER_PAGE = 10

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

  scope :published, -> { where(is_draft: false, is_public: true) }
  scope :with_draft, -> { where(is_draft: true) }
  scope :without_draft, -> { where(is_draft: false) }

  scope :popular_in_last_3_days, lambda {
    joins(:favorite_recipes)
      .merge(FavoriteRecipe.created_in_last_3_days)
      .group('recipes.id')
      .order('COUNT(favorite_recipes.id) DESC')
  }

  scope :not_favorited_in_last_3_days, lambda {
    where.not(id: popular_in_last_3_days.pluck(:id))
  }

  # NOTE: 引数のユーザーが作成したレシピを人気順に並べる
  scope :popular_recipes_by_user, lambda { |user_id|
    left_joins(:favorite_recipes)
      .where(user_id:)
      .group('recipes.id')
      .order('COUNT(favorite_recipes.id) DESC')
  }

  # NOTE: 引数のユーザーが作成したレシピを新着順に並べる
  scope :new_arrival_recipes_by_user, lambda { |user_id|
    where(user_id:).order(created_at: :desc)
  }

  scope :by_chef, lambda {
    joins(:user).where(users: { user_type: 'chef' })
  }

  scope :search_by_name, lambda { |keyword|
    where('recipes.name LIKE ?', "%#{keyword}%")
  }

  delegate :count, to: :favoriters, prefix: true
  delegate :user_type, to: :user

  alias author_type user_type

  def self.ordered_by_recent_favorites_and_others
    where(id: popular_in_last_3_days.pluck(:id) + not_favorited_in_last_3_days.pluck(:id))
  end

  def is_favorite?(user)
    favoriters.exists?(id: user.id)
  end

  def self.paginate(page, per_page = PER_PAGE)
    offset = (page - 1) * per_page
    limit(per_page).offset(offset)
  end
end
