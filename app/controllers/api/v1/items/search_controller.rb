class Api::V1::Items::SearchController < ApplicationController
  def index 
    params_check
    item_json_response(@items)
  end

  private 
    def params_check 
      if (params.has_key?(:name)) && ((params.has_key?(:min_price)) || (params.has_key?(:max_price)))
        raise ActiveRecord::RecordInvalid.new
      elsif params[:name]
        @items = Item.find_name(params[:name])
      elsif params[:min_price] && params[:max_price]
        @items = Item.min_max(params[:min_price], params[:max_price])
      elsif params[:min_price]
        @items = Item.min_price(params[:min_price])
      elsif params[:max_price]
        @items = Item.max_price(params[:max_price])
      end
    end
end