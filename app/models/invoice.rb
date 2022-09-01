class Invoice < ApplicationRecord
  has_many :invoice_items, dependent: :delete_all 
  has_many :items, through: :invoice_items
  belongs_to :customer 

  def check_dependent_destroy
    if items.count == 1 
      self.destroy 
    end
  end

  def single_item? 
    items.count == 1 
  end
end