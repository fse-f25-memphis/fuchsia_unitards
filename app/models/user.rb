class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :unitards, foreign_key: :vendor_id, dependent: :nullify
  has_one  :cart, dependent: :destroy
  has_many :orders, dependent: :nullify
  has_many :reviews, dependent: :destroy
  has_many :trades_sent, class_name: "Trade", foreign_key: :proposer_id, dependent: :destroy
  has_many :trades_received, class_name: "Trade", foreign_key: :recipient_id, dependent: :destroy
  has_many :wishlist_items, dependent: :destroy
  has_many :wishlisted_unitards, through: :wishlist_items, source: :unitard

  def vendor?
    role == "vendor"
  end
end
