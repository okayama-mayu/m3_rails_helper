class Api::V1::Items::SearchController < ApplicationController
  def index 
    if params[:name]
      items = Item.find_name(params[:name])
      test = item_json_response(items)
    end
  end
end