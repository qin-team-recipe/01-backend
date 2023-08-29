module UrlTypePattern
  extend ActiveSupport::Concern

  URL_TYPES = {
    youtube: 'youtube',
    instagram: 'instagram',
    tiktok: 'tiktok',
    twitter: 'twitter',
    facebook: 'facebook'
  }.freeze
end
