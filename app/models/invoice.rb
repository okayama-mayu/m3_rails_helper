class Invoice < ApplicationRecord
  has_many :invoice_items, dependent: :destroy 
  has_many :items, through: :invoice_items
  belongs_to :customer 

  def check_dependent_destroy
    if items.empty?
      self.destroy 
    end
  end
end