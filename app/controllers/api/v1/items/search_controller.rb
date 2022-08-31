class Api::V1::Items::SearchController < ApplicationController
  def index 
    if params[:name]
      items = Item.find_name(params[:name])
      item_json_response(items)
    elsif params[:min_price]
      items = Item.min_price(params[:min_price])
      item_json_response(items)
    end
  end
end