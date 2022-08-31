class Merchant < ApplicationRecord
  validates_presence_of :name

  has_many :items, dependent: :destroy 

  def check_dependent_destroy
    if self.items.empty? 
      self.destroy 
    end 
  end

  def self.find_matches(query)
    Merchant.where("lower(name) LIKE ?", "%#{query.downcase}%").order(:name)
  end
end
