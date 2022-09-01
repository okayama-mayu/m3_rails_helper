require 'rails_helper' 

RSpec.describe Invoice, type: :model do 
  describe 'relationships' do 
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items) }
    it { should belong_to :customer }
  end

  describe 'instance method' do 
    it 'deletes the Invoice and associated Invoice Items if it has no Items' do 
      customer = Customer.create!(first_name: 'Carlos', last_name: 'Stich')
      merchant = create(:merchant)
      invoice = Invoice.create!(customer_id: customer.id, merchant_id: merchant.id, status: 'pending')
      item = merchant.items.create!(name: 'phone', description: 'abc', unit_price: 5.0)
      invoice_item = InvoiceItem.create!(item_id: item.id, invoice_id: invoice.id, quantity: 2, unit_price: 5.0)

      item.destroy 

      invoice.check_dependent_destroy 

      expect(Invoice.count).to eq 0 
      expect{Invoice.find(invoice.id)}.to raise_error(ActiveRecord::RecordNotFound)
      expect{InvoiceItem.find(invoice_item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'does not delete the Invoice if it has an Item' do 
      customer = Customer.create!(first_name: 'Carlos', last_name: 'Stich')
      merchant = create(:merchant)
      invoice = Invoice.create!(customer_id: customer.id, merchant_id: merchant.id, status: 'pending')
      item = merchant.items.create!(name: 'phone', description: 'abc', unit_price: 5.0)
      invoice_item = InvoiceItem.create!(item_id: item.id, invoice_id: invoice.id, quantity: 2, unit_price: 5.0)

      invoice.check_dependent_destroy 

      expect(Invoice.count).to eq 1
      expect(Invoice.find(invoice.id)).to eq invoice 
      expect(InvoiceItem.find(invoice_item.id)).to eq invoice_item
    end
  end
end