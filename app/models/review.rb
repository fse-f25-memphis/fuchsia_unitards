class Review < ApplicationRecord
  belongs_to :user
  belongs_to :unitard

  validates :rating, inclusion: { in: 1..5 }
  validates :title, presence: true
  validates :comment, presence: true
end