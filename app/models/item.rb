class Item < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :unit_price
  validates :unit_price, numericality: true 

  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

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

  def delete_invoice_items
    invoice_items.each { |ii| ii.delete }
  end

  def single_item_invoice
    invoices.select do |i| 
      i.items.count == 1 
    end
  end

  def delete_single_item_invoices
    single_item_invoice.each do |invoice| 
      delete_invoice_items
      invoice.delete 
    end 
  end
end