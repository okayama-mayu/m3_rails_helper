class Api::V1::MerchantItemsController < ApplicationController
  def index 
    merchant = Merchant.find(params[:merchant_id])
    items = merchant.items
    item_json_response(items)
  end
end