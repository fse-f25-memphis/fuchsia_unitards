class Trade < ApplicationRecord
  belongs_to :proposer, class_name: "User"
  belongs_to :recipient, class_name: "User"
  has_many :trade_items, dependent: :destroy
  has_many :unitards, through: :trade_items

  enum status: { pending: "pending", accepted: "accepted", rejected: "rejected" }, _prefix: true
end