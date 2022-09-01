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
    # check if Item is the only one on each Invoice 
    # if true, delete the Invoice and associated InvoiceItems
    @item.delete_single_item_invoices
    # destroy all InvoiceItems associated with the Item
    @item.delete_invoice_items
    render json: Item.destroy(params[:id])
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