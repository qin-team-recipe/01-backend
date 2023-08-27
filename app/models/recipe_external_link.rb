class RecipeExternalLink < ApplicationRecord
  belongs_to :recipe

  URL_TYPES = {
    youtube: 'YouTube',
    instagram: 'Instagram',
    tiktok: 'TikTok',
    twitter: 'Twitter',
    facebook: 'Facebook'
  }.freeze

  validates :url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp, message: 'のフォーマットが正しくありません' }
  validates :recipe_id, uniqueness: { scope: :url_type }, allow_nil: true, unless: -> { url_type.nil? }
  validates :recipe_id, uniqueness: { scope: :url }
  validates :url_type, inclusion: { in: URL_TYPES.values }, allow_nil: true
end
