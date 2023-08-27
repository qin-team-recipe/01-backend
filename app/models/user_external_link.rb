class UserExternalLink < ApplicationRecord
  include UrlTypePattern

  belongs_to :user

  validates :url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp, message: 'のフォーマットが正しくありません' }
  validates :user_id, uniqueness: { scope: :url_type }, allow_nil: true, unless: -> { url_type.nil? }
  validates :user_id, uniqueness: { scope: :url }
  validates :url_type, inclusion: { in: URL_TYPES.values }, allow_nil: true
end
