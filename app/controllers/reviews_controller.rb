class ReviewsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_unitard
  
    def new
      @review = @unitard.reviews.new
    end
  
    def create
      @review = @unitard.reviews.new(review_params.merge(user: current_user))
      if @review.save
        redirect_to @unitard, notice: "Review submitted."
      else
        render :new, status: :unprocessable_entity
      end
    end
  
    private
  
    def set_unitard
      @unitard = Unitard.find(params[:unitard_id])
    end
  
    def review_params
      params.require(:review).permit(:rating, :comment)
    end
  end
  