class RecipeExternalLink < ApplicationRecord
  include UrlTypePattern

  belongs_to :recipe

  validates :url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp, message: 'のフォーマットが正しくありません' }
  validates :recipe_id, uniqueness: { scope: :url_type }, unless: -> { url_type.nil? }
  validates :recipe_id, uniqueness: { scope: :url }
  validates :url_type, inclusion: { in: URL_TYPES.values }, allow_nil: true
end
