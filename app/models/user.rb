class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :recipes, dependent: :destroy
  has_many :favorite_recipes, dependent: :destroy
  has_many :cart_lists, dependent: :destroy
  has_many :favorited_recipes, through: :favorite_recipes, source: :recipe
  has_many :user_external_links, dependent: :destroy
  has_many :active_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy, inverse_of: :follower
  has_many :following, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy, inverse_of: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  # バリデーション
  validates :name, presence: true
  validates :email, presence: true
  validates :domain, presence: true
  validates :type, presence: true
  validates :email, uniqueness: { case_sensitive: false }
  validates :domain, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email format" }
  validates :type, inclusion: { in: ['user', 'chef'] }

  # 名前系：100文字以内、説明系：256文字以内で一旦設定
  validates :name, length: { maximum: 100 }
  validates :description, length: { maximum: 256 }

end
