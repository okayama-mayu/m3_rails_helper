module ExceptionHandler
  extend ActiveSupport::Concern 

  included do 
    rescue_from ActiveRecord::RecordNotFound do |e| 
      binding.pry 
      json_response({ message: e.message }, :not_found)
    end

    rescue_from ActiveRecord::RecordInvalid do |e| 
      binding.pry 
      json_response({ message: e.message }, :unprocessable_entity)
    end
  end 
end