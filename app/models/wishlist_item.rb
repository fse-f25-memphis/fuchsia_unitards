class WishlistItem < ApplicationRecord
  belongs_to :user
  belongs_to :unitard

  validates :unitard_id, uniqueness: { scope: :user_id }
end
