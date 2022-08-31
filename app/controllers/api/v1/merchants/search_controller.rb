class Api::V1::Merchants::SearchController < ApplicationController
  def show 
    merchant = Merchant.all.find_matches(params[:name])
    binding.pry 
    merchant_json_response(merchant)
  end
end