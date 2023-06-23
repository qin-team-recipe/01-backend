class Chef < ApplicationRecord
  has_many :recipes, as: :author
end
