class Step < ApplicationRecord
  belongs_to :recipe

  validates :description, presence: true, length: { maximum: 256 }
  validates :position, presence: true
end
