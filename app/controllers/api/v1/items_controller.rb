class Api::V1::ItemsController < ApplicationController 
  before_action :set_item, only: [:show, :update, :destroy ]

  def index 
    # render json: Item.all 
    @items = Item.all 
    item_json_response(@items)
  end

  def show
    item_json_response(@item)
  end

  def create
    @item = Item.create!(item_params)
    item_json_response(@item, :created)
  end

  def update 
    @item.update!(item_params)
    item_json_response(@item)
  end

  def destroy
    invoice = @item.invoice
    render json: Item.delete(params[:id])
    invoice.check_dependent_destroy
    head :no_content
  end

  private 
    def set_item
      @item = Item.find(params[:id])
    end

    def item_params 
      params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
    end
end