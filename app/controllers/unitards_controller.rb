class UnitardsController < ApplicationController
    before_action :set_unitard, only: %i[show edit update destroy toggle_wishlist]
    before_action :authenticate_user!, except: %i[index show]
  
    def index
      @unitards = Unitard.all
  
      if params[:query].present?
        q = "%#{params[:query]}%"
        @unitards = @unitards.where("name ILIKE ? OR description ILIKE ?", q, q)
      end
  
      if params[:size].present?
        @unitards = @unitards.where(size: params[:size])
      end
  
      if params[:color].present?
        @unitards = @unitards.where(color: params[:color])
      end
  
      if params[:sort].present?
        case params[:sort]
        when "price_asc" then @unitards = @unitards.order(price: :asc)
        when "price_desc" then @unitards = @unitards.order(price: :desc)
        end
      end
    end
  
    def show; end
  
    def new
      @unitard = current_user.unitards.build
    end
  
    def create
      @unitard = current_user.unitards.build(unitard_params)
      if @unitard.save
        redirect_to @unitard, notice: "Unitard created."
      else
        render :new, status: :unprocessable_entity
      end
    end
  
    def edit; end
  
    def update
      if @unitard.update(unitard_params)
        redirect_to @unitard, notice: "Unitard updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end
  
    def destroy
      @unitard.destroy
      redirect_to unitards_path, notice: "Unitard removed."
    end
  
    def toggle_wishlist
      item = current_user.wishlist_items.find_by(unitard: @unitard)
      if item
        item.destroy
        msg = "Removed from wishlist."
      else
        current_user.wishlist_items.create!(unitard: @unitard)
        msg = "Added to wishlist."
      end
      redirect_to @unitard, notice: msg
    end
  
    private
  
    def set_unitard
      @unitard = Unitard.find(params[:id])
    end
  
    def unitard_params
      params.require(:unitard).permit(:name, :description, :price, :cut,
                                      :size, :sleeves, :graphic, :color,
                                      :special_features, :stock)
    end
  end
  