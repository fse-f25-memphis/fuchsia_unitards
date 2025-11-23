class WishlistItemsController < ApplicationController
  before_action :authenticate_user!

  def index
    @wishlist_items = current_user.wishlist_items.includes(:unitard)
  end

  def create
    unitard = Unitard.find(params[:unitard_id])
    current_user.wishlist_items.create!(unitard: unitard)
    redirect_to wishlist_items_path, notice: "Added to wishlist!"
  end

  def destroy
    item = current_user.wishlist_items.find(params[:id])
    item.destroy
    redirect_to wishlist_items_path, notice: "Removed from wishlist."
  end
end
