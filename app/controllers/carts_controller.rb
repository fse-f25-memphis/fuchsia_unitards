class CartsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_cart
  
    def show
      # @cart is set in before_action
    end
  
    def add
      unitard = Unitard.find(params[:unitard_id])
      item = @cart.cart_items.find_or_initialize_by(unitard: unitard)
  
      # ✅ Handle nil quantity on new records
      item.quantity = (item.quantity || 0) + 1
  
      item.save!
      redirect_to cart_path, notice: "Added to cart."
    end
  
    def update_item
      item = @cart.cart_items.find(params[:id])
      item.update!(quantity: params[:cart_item][:quantity])
      redirect_to cart_path, notice: "Cart updated."
    end
  
    def remove_item
      item = @cart.cart_items.find(params[:id])
      item.destroy
      redirect_to cart_path, notice: "Item removed from cart."
    end
  
    private
  
    def set_cart
      @cart = current_user.cart || current_user.create_cart
    end
  end
  