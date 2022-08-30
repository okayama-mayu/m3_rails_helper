module ExceptionHandler
  extend ActiveSupport::Concern 

  included do 
    rescue_from ActiveRecord::RecordNotFound do |e| 
      merchant_json_response({ message: e.message }, :not_found)
    end

    rescue_from ActiveRecord::RecordNotFound do |e| 
      item_json_response({ message: e.message }, :not_found)
    end

    rescue_from ActiveRecord::RecordInvalid do |e| 
      merchant_json_response({ message: e.message }, :unprocessable_entity)
    end

    rescue_from ActiveRecord::RecordInvalid do |e| 
      item_json_response({ message: e.message }, :unprocessable_entity)
    end
  end 
end