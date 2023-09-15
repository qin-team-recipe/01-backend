class User < ApplicationRecord
  authenticates_with_sorcery!

  PER_PAGE = 10

  has_many :recipes, dependent: :destroy
  has_many :favorite_recipes, dependent: :destroy
  has_many :cart_lists, dependent: :destroy
  has_many :favorited_recipes, through: :favorite_recipes, source: :recipe
  has_many :user_external_links, dependent: :destroy
  has_many :active_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy, inverse_of: :follower
  has_many :following, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy, inverse_of: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  # 名前系：100文字以内、説明系：256文字以内で一旦設定
  validates :name, presence: true, length: { maximum: 100 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP, message: 'のフォーマットが正しくありません' }
  validates :domain, presence: true, uniqueness: true
  validates :user_type, presence: true, inclusion: { in: ['user', 'chef'] }
  validates :description, length: { maximum: 256 }

  after_create :create_cart_list

  scope :by_type_chef, lambda {
    where(user_type: 'chef')
  }

  scope :order_by_name, lambda {
    order(:name)
  }

  scope :search_by_name, lambda { |keyword|
    where('name LIKE ?', "%#{keyword}%")
  }

  def follow!(other_user)
    raise ArgumentError if other_user == self

    following << other_user
  end

  def unfollow!(following_user)
    follow_relationship = active_relationships.find_by(followed_id: following_user.id)
    raise ArgumentError if follow_relationship.nil?

    follow_relationship.destroy!
  end

  def self.paginate(page, per_page = PER_PAGE)
    offset = (page - 1) * per_page
    limit(per_page).offset(offset)
  end

  private

  def create_cart_list
    cart_lists.create(name: 'じぶんメモ', position: 1, own_notes: true)
  end
end
