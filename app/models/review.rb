class Review < ApplicationRecord
  belongs_to :user
  belongs_to :unitard

  validates :rating, inclusion: 1..5
end
