class OrdersController < ApplicationController
  before_action :authenticate_user!

  # GET /orders - My Orders page
  def index
    @orders = current_user.orders.order(created_at: :desc)
  end

  # GET /orders/:id - Order details
  def show
    @order = current_user.orders.find(params[:id])
  end

  # GET /orders/checkout - Checkout page with address form
  def checkout
    @cart = current_user.cart
    redirect_to cart_path, alert: "Your cart is empty." and return if @cart.blank? || @cart.cart_items.empty?

    @cart_items = @cart.cart_items.includes(:unitard)
    @total = @cart_items.sum { |item| item.unitard.price * item.quantity }
    @order = current_user.orders.new
  end

  # POST /orders/place_order - Create order and redirect to payment
  def place_order
    @cart = current_user.cart
    redirect_to cart_path, alert: "Your cart is empty!" and return if @cart.blank? || @cart.cart_items.empty?

    @cart_items = @cart.cart_items.includes(:unitard)
    
    # Calculate subtotal
    subtotal = @cart_items.sum { |item| item.unitard.price * item.quantity }
    
    # Calculate tax (10%)
    tax = subtotal * 0.10
    
    # Calculate total with tax
    total_with_tax = subtotal + tax
    
    # Create order with shipping address
    @order = current_user.orders.new(order_params)
    @order.status = 'pending'
    @order.payment_status = 'pending'
    @order.total = total_with_tax

    ActiveRecord::Base.transaction do
      if @order.save
        # Create order items from cart
        @cart_items.each do |cart_item|
          @order.order_items.create!(
            unitard: cart_item.unitard,
            quantity: cart_item.quantity,
            price: cart_item.unitard.price
          )
        end

        # Store order ID in session for payment page
        session[:pending_order_id] = @order.id

        # Redirect to payment selection
        redirect_to payment_order_path(@order)
      else
        flash.now[:alert] = "Please fill in all required address fields."
        @total = total_with_tax
        render :checkout, status: :unprocessable_entity
      end
    end
  rescue => e
    flash[:alert] = "Error creating order: #{e.message}"
    redirect_to checkout_orders_path
  end

  # GET /orders/:id/payment - Payment selection page
  def payment
    @order = current_user.orders.find(params[:id])
    
    if @order.payment_status != 'pending'
      redirect_to order_path(@order), alert: "This order has already been processed."
      return
    end
  end

  # POST /orders/:id/process_payment - Process payment (simulated)
  def process_payment
    @order = current_user.orders.find(params[:id])
    payment_method = params[:payment_method]

    if payment_method.blank?
      redirect_to payment_order_path(@order), alert: "Please select a payment method."
      return
    end

    # Simulate payment processing
    sleep(1) # Simulate processing delay

    # Update order with payment info and set to completed for review
    @order.update!(
      payment_method: payment_method,
      payment_status: 'paid',
      status: 'completed',  # Set to completed so review button appears
      tracking_number: "TRACK#{Time.now.to_i}#{rand(1000..9999)}"  # Generate tracking number
    )

    # Clear the cart
    current_user.cart.cart_items.destroy_all

    # Clear session
    session.delete(:pending_order_id)

    # Redirect to success page
    redirect_to success_order_path(@order)
  rescue => e
    redirect_to payment_order_path(@order), alert: "Payment processing failed: #{e.message}"
  end

  # GET /orders/:id/success - Order success page
  def success
    @order = current_user.orders.includes(order_items: :unitard).find(params[:id])
    
    if @order.payment_status != 'paid'
      redirect_to orders_path, alert: "Invalid order access."
      return
    end
  end

  private

  def order_params
    params.require(:order).permit(
      :shipping_street,
      :shipping_city,
      :shipping_state,
      :shipping_zip,
      :shipping_country,
      :gift,
      :recipient_name,
      :recipient_email,
      :gift_message
    )
  end
end