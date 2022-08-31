class Api::V1::Items::SearchController < ApplicationController
  def index 
    if params[:name]
      items = Item.find_name(params[:name])
    elsif params[:min_price]
      items = Item.min_price(params[:min_price])
    elsif params[:max_price]
      items = Item.max_price(params[:max_price])
    end
    item_json_response(items)
  end
end