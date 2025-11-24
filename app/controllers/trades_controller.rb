class TradesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_trade, only: [:show, :update, :edit, :cancel]
  before_action :set_owned_unitards, only: [:new, :create, :edit]

  def index
    @trades = Trade.where("proposer_id = ? OR recipient_id = ?", current_user.id, current_user.id).order(created_at: :desc)
  end

  def show
    authorize_trade!
  end

  def new
    @trade = Trade.new
    @all_unitards = Unitard.all # Browse entire catalog
  end

  def create
    @trade = Trade.new(trade_params)
    @trade.proposer = current_user
    @trade.status = "pending"

    if @trade.save
      # Proposer's offered items (from their owned unitards)
      (params[:proposer_unitard_ids] || []).each do |uid|
        next if uid.blank?
        @trade.trade_items.create!(unitard_id: uid, side: "proposer")
      end

      # Recipient's requested items (from entire catalog)
      (params[:recipient_unitard_ids] || []).each do |uid|
        next if uid.blank?
        @trade.trade_items.create!(unitard_id: uid, side: "recipient")
      end

      redirect_to trades_path, notice: "Trade proposal sent successfully!"
    else
      @all_unitards = Unitard.all
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize_proposer!
    redirect_to trades_path, alert: "Cannot modify accepted or rejected trade." unless @trade.status == "pending"
    @all_unitards = Unitard.all
  end

  def update
    authorize_trade!

    # Handle accept/reject by recipient
    if params[:decision].present?
      case params[:decision]
      when "accept"
        @trade.update!(status: "accepted")
        redirect_to trades_path, notice: "Trade accepted!"
      when "reject"
        @trade.update!(status: "rejected")
        redirect_to trades_path, notice: "Trade rejected."
      end
      return
    end

    # Handle modify by proposer
    authorize_proposer!
    
    if @trade.update(trade_params)
      # Clear existing trade items
      @trade.trade_items.destroy_all

      # Re-add proposer's items
      (params[:proposer_unitard_ids] || []).each do |uid|
        next if uid.blank?
        @trade.trade_items.create!(unitard_id: uid, side: "proposer")
      end

      # Re-add recipient's items
      (params[:recipient_unitard_ids] || []).each do |uid|
        next if uid.blank?
        @trade.trade_items.create!(unitard_id: uid, side: "recipient")
      end

      redirect_to @trade, notice: "Trade proposal updated successfully!"
    else
      @all_unitards = Unitard.all
      render :edit, status: :unprocessable_entity
    end
  end

  def cancel
    authorize_proposer!
    
    if @trade.status == "pending"
      @trade.update!(status: "cancelled")
      redirect_to trades_path, notice: "Trade cancelled successfully."
    else
      redirect_to @trade, alert: "Cannot cancel this trade."
    end
  end

  private

  def set_trade
    @trade = Trade.find(params[:id])
  end

  def trade_params
    params.require(:trade).permit(:recipient_id)
  end

  def authorize_trade!
    unless [@trade.proposer_id, @trade.recipient_id].include?(current_user.id)
      redirect_to trades_path, alert: "Not authorized."
    end
  end

  def authorize_proposer!
    unless @trade.proposer_id == current_user.id
      redirect_to trades_path, alert: "Only proposer can perform this action."
    end
  end

  def set_owned_unitards
    @owned_unitards = current_user.orders
      .where(status: "completed")
      .joins(:order_items)
      .includes(order_items: :unitard)
      .flat_map(&:order_items)
      .map(&:unitard)
      .uniq
  end
end