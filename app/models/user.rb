class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :recipes, as: :author
end
