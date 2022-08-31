class Api::V1::Merchants::SearchController < ApplicationController
  def show 
    merchant = Merchant.find_merchant(params[:name])
    data = merchant_json_response(merchant)
  end
end