module Response 
  def merchant_json_response(object, status = :ok)
    if object == nil 
      render json: "{\"data\":{}}"
    else
      render json: MerchantSerializer.new(object), status: status
    end
  end

  def item_json_response(object, status = :ok)
    if object == []
      test = render json: "{\"data\":{}}"
    else 
      render json: ItemSerializer.new(object), status: status
    end
  end

  def error_response(message, status)
    render json: message, status: 404 
  end
end