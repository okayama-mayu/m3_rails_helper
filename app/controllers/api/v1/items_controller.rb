class Api::V1::ItemsController < ApplicationController 
  before_action :set_item, only: [:show]

  def index 
    # render json: Item.all 
    @items = Item.all 
    item_json_response(@items)
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    item = render json: Item.new(item_params)
    # if item.save 
    #   render json: ItemSerializer.new(Item.last), status: 201 
    # else 
    #   render status: 
    # end
  end

  private 
    def set_item
      @item = Item.find(params[:id])
    end

    def item_params 
      params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
    end
end