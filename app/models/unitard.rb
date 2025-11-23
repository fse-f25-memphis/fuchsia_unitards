class Unitard < ApplicationRecord
  belongs_to :vendor, class_name: "User"

  has_many :cart_items, dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_many :wishlist_items, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :trade_items, dependent: :destroy

  validates :name, :price, :stock, presence: true
end
