class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_unitard, only: [:new]

  def new
    @review = @unitard.reviews.new
  end

  def create
    @unitard = Unitard.find(params[:review][:unitard_id])
    @review = @unitard.reviews.new(review_params.merge(user: current_user))
    
    if @review.save
      redirect_to order_path(params[:review][:order_id]), notice: "Review submitted successfully!"
    else
      redirect_to order_path(params[:review][:order_id]), alert: "Failed to submit review: #{@review.errors.full_messages.join(', ')}"
    end
  end

  private

  def set_unitard
    @unitard = Unitard.find(params[:unitard_id])
  end

  def review_params
    params.require(:review).permit(:rating, :title, :comment)
  end
end