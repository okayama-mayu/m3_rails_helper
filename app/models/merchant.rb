class Merchant < ApplicationRecord
  validates_presence_of :name

  has_many :items, dependent: :destroy 

  def check_dependent_destroy
    if self.items.empty? 
      self.destroy 
    end 
  end
end
