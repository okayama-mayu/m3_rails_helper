class Invoice < ApplicationRecord
  has_many :invoice_items
  has_many :items, through: :invoice_items

  def check_dependent_destroy
    
  end
end