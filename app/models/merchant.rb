class Merchant < ApplicationRecord
  validates_presence_of :name

  has_many :items, dependent: :destroy 

  def check_dependent_destroy
    if items.empty? 
      self.destroy 
    end 
  end

  def self.find_matches(query)
    where("lower(name) LIKE ?", "%#{query.downcase}%")
    .order(:name)
  end

  def self.find_merchant(query)
    find_matches(query).first 
  end
end
