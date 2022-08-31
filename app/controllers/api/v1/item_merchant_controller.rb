class Api::V1::ItemMerchantController < ApplicationController
  def index 
    item = Item.find(params[:item_id])
    merchant = item.merchant 
    merchant_json_response(merchant)
  end
end