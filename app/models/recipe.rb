class Recipe < ApplicationRecord
  belongs_to :author, polymorphic: true
end
