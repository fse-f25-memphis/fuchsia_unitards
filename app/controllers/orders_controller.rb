class OrdersController < ApplicationController
    before_action :authenticate_user!
  
    def index
      @orders = current_user.orders.order(created_at: :desc)
    end
  
    def show
      @order = current_user.orders.find(params[:id])
    end
  
    def new
      @cart = current_user.cart
      redirect_to cart_path, alert: "Your cart is empty." and return if @cart.blank? || @cart.cart_items.empty?
  
      @order = current_user.orders.new
    end
  
    def create
      @cart = current_user.cart
      @order = current_user.orders.new(order_params)
      @order.status = "paid" # assuming successful payment for now
      @order.total = @cart.cart_items.includes(:unitard).sum { |i| i.quantity * i.unitard.price }
  
      if @order.save
        @cart.cart_items.each do |item|
          @order.order_items.create!(
            unitard: item.unitard,
            quantity: item.quantity,
            price: item.unitard.price
          )
        end
        @cart.cart_items.destroy_all
        redirect_to @order, notice: "Order placed successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end
  
    private
  
    def order_params
      params.require(:order).permit(:gift, :recipient_name, :recipient_email, :gift_message)
    end
  end
  