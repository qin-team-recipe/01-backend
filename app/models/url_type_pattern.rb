module UrlTypePattern
  extend ActiveSupport::Concern

  URL_TYPES = {
    youtube: 'YouTube',
    instagram: 'Instagram',
    tiktok: 'TikTok',
    twitter: 'Twitter',
    facebook: 'Facebook'
  }.freeze
end
