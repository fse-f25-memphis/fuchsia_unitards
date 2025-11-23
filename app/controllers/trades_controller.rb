class TradesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_owned_unitards, only: [:new, :create]
  
    def index
      @trades = Trade.where("proposer_id = ? OR recipient_id = ?", current_user.id, current_user.id)
    end
  
    def show
      @trade = Trade.find(params[:id])
      authorize_trade!
    end
  
    def new
      @trade = Trade.new
      # @owned_unitards is set by set_owned_unitards
    end
  
    def create
      @trade = Trade.new(trade_params)
      @trade.proposer = current_user
      @trade.status   = "pending"
  
      if @trade.save
        # For simplicity, assume params contain arrays of unitard IDs
        (params[:proposer_unitard_ids] || []).each do |uid|
          next if uid.blank?
          @trade.trade_items.create!(unitard_id: uid, side: "proposer")
        end
  
        (params[:recipient_unitard_ids] || []).each do |uid|
          next if uid.blank?
          @trade.trade_items.create!(unitard_id: uid, side: "recipient")
        end
  
        redirect_to trades_path, notice: "Trade proposal sent."
      else
        # @owned_unitards is still available here because of before_action
        render :new, status: :unprocessable_entity
      end
    end
  
    def update
      @trade = Trade.find(params[:id])
      authorize_trade!
  
      case params[:decision]
      when "accept"
        @trade.update!(status: "accepted")
        # real system: swap ownership etc.
      when "reject"
        @trade.update!(status: "rejected")
      end
  
      redirect_to trades_path, notice: "Trade updated."
    end
  
    private
  
    def trade_params
      params.require(:trade).permit(:recipient_id)
    end
  
    def authorize_trade!
      unless [@trade.proposer_id, @trade.recipient_id].include?(current_user.id)
        redirect_to trades_path, alert: "Not authorized."
      end
    end
  
    def set_owned_unitards
      # All unitards this user actually owns (via completed orders)
      @owned_unitards =
        current_user.orders
                    .joins(:order_items)
                    .includes(order_items: :unitard)
                    .flat_map(&:order_items)
                    .map(&:unitard)
                    .uniq
    end
  end
  