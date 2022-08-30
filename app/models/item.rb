class Item < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :unit_price
  validates :unit_price, numericality: true 

  belongs_to :merchant
end