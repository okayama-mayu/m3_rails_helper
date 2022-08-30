module Response 
  def json_response(object, status = :ok)
    render json: MerchantSerializer.new(object), status: status
  end
end