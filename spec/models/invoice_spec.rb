require 'rails_helper' 

RSpec.describe Invoice, type: :model do 
  describe 'relationships' do 
    it { should have_many :invoice_items }
    it { should belong_to :customer }
    it { should have_many(:items).through(:invoice_items)}
  end

  describe 'instance method' do 
    it 'deletes the Invoice and associated Invoice Items if it has one Item' do 
      customer = Customer.create!(first_name: 'Carlos', last_name: 'Stich')
      merchant = create(:merchant)
      invoice = Invoice.create!(customer_id: customer.id, merchant_id: merchant.id, status: 'pending')
      item = merchant.items.create!(name: 'phone', description: 'abc', unit_price: 5.0)
      invoice_item = InvoiceItem.create!(item_id: item.id, invoice_id: invoice.id, quantity: 2, unit_price: 5.0)

      invoice.check_dependent_destroy 

      expect(Invoice.count).to eq 0 
      expect{Invoice.find(invoice.id)}.to raise_error(ActiveRecord::RecordNotFound)
      # expect{InvoiceItem.find(invoice_item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'does not delete the Invoice if it has more than one an Item' do 
      customer = Customer.create!(first_name: 'Carlos', last_name: 'Stich')
      merchant = create(:merchant)
      invoice = Invoice.create!(customer_id: customer.id, merchant_id: merchant.id, status: 'pending')
      item_1 = merchant.items.create!(name: 'phone', description: 'abc', unit_price: 5.0)
      item_2 = merchant.items.create!(name: 'phone2', description: 'abc', unit_price: 5.0)
      invoice_item_1 = InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice.id, quantity: 2, unit_price: 5.0)
      invoice_item_2 = InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice.id, quantity: 2, unit_price: 5.0)

      invoice.check_dependent_destroy 

      expect(Invoice.count).to eq 1
      expect(Invoice.find(invoice.id)).to eq invoice 
      expect(InvoiceItem.find(invoice_item_1.id)).to eq invoice_item_1
      expect(InvoiceItem.find(invoice_item_2.id)).to eq invoice_item_2
    end
  end
end