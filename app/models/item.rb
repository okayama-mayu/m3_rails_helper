class Item < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :unit_price
  validates :unit_price, numericality: true 

  belongs_to :merchant

  def self.find_name(query)
    where("lower(name) LIKE ?", "%#{query.downcase}%")
    .order(:name)
  end

  def self.min_price(query)
    where("unit_price >= ?", query)
    .order(:name)
  end

  def self.max_price(query)
    where("unit_price <= ?", query)
    .order(:name)
  end

  def self.min_max(min, max)
    where("unit_price >= ?", min)
    .where("unit_price <= ?", max)
    .order(:name)
  end
end