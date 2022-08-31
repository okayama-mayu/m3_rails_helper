class Api::V1::MerchantsController < ApplicationController 
  before_action :set_merchant, only: [:show]

  def index 
    # render json: Merchant.all 
    # render json: MerchantSerializer.new(Merchant.all)
    merchants = Merchant.all 
    merchant_json_response(merchants)
  end

  def show 
    # render json: Merchant.find(params[:id])
    # render json: MerchantSerializer.new(Merchant.find(params[:id]))
    merchant_json_response(@merchant)
  end

  def find 
    
  end

  private 

  def set_merchant
    @merchant = Merchant.find(params[:id])
  end
end