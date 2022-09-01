require 'rails_helper' 

RSpec.describe Item, type: :model do 
  describe 'validations' do 
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_numericality_of(:unit_price) }
  end

  describe 'relationships' do 
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items)}
  end

  describe 'instance methods' do 
    it 'deletes associated Invoice Items' do 
      customer = Customer.create!(first_name: 'Carlos', last_name: 'Stich')
      merchant = create(:merchant)
      invoice_1 = Invoice.create!(customer_id: customer.id, merchant_id: merchant.id, status: 'pending')
      invoice_2 = Invoice.create!(customer_id: customer.id, merchant_id: merchant.id, status: 'pending')
      item_1 = merchant.items.create!(name: 'phone', description: 'abc', unit_price: 5.0)
      item_2 = merchant.items.create!(name: 'phone2', description: 'abc', unit_price: 5.0)
      invoice_item_1 = InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice_1.id, quantity: 2, unit_price: 5.0)
      invoice_item_2 = InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice_2.id, quantity: 2, unit_price: 5.0)

      item_1.delete_invoice_items 

      expect(InvoiceItem.count).to eq 0 
      expect{InvoiceItem.find(invoice_item_1.id)}.to raise_error(ActiveRecord::RecordNotFound)
      expect{InvoiceItem.find(invoice_item_2.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
    
    it 'returns an array of Invoices with no other Items' do 
      customer = Customer.create!(first_name: 'Carlos', last_name: 'Stich')
      merchant = create(:merchant)
      invoice_1 = Invoice.create!(customer_id: customer.id, merchant_id: merchant.id, status: 'pending')
      invoice_2 = Invoice.create!(customer_id: customer.id, merchant_id: merchant.id, status: 'pending')
      invoice_3 = Invoice.create!(customer_id: customer.id, merchant_id: merchant.id, status: 'pending')
      item_1 = merchant.items.create!(name: 'phone', description: 'abc', unit_price: 5.0)
      item_2 = merchant.items.create!(name: 'phone2', description: 'abc', unit_price: 5.0)
      invoice_item_1 = InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice_1.id, quantity: 2, unit_price: 5.0)
      invoice_item_2 = InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice_2.id, quantity: 2, unit_price: 5.0)
      invoice_item_3a = InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice_3.id, quantity: 2, unit_price: 5.0)
      invoice_item_3b = InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice_3.id, quantity: 2, unit_price: 5.0)

      expect(item_1.single_item_invoice).to eq([invoice_1, invoice_2])
    end
  end

  describe 'class methods' do 
    it 'returns a list of Items matching a name query in alpha order' do 
      merchant = create(:merchant)

      llama = Item.create!(name: 'Llama', description: 'abc', unit_price: 5.0, merchant_id: merchant.id)
      ball = Item.create!(name: 'Ball', description: 'abc', unit_price: 5.0, merchant_id: merchant.id)
      bell = Item.create!(name: 'Bell', description: 'abc', unit_price: 5.0, merchant_id: merchant.id)
      dress = Item.create!(name: 'Dress', description: 'abc', unit_price: 5.0, merchant_id: merchant.id)

      expect(Item.find_name('ll')).to eq([ball, bell, llama])
    end

    it 'returns a list of Items matching a minimum price query in alpha order' do 
      merchant = create(:merchant)

      llama = Item.create!(name: 'Llama', description: 'abc', unit_price: 5.0, merchant_id: merchant.id)
      dress = Item.create!(name: 'Dress', description: 'abc', unit_price: 20.0, merchant_id: merchant.id)
      ball = Item.create!(name: 'Ball', description: 'abc', unit_price: 10.0, merchant_id: merchant.id)
      bell = Item.create!(name: 'Bell', description: 'abc', unit_price: 15.0, merchant_id: merchant.id)

      expect(Item.min_price(10)).to eq([ball, bell, dress])
    end

    it 'returns a list of Items matching a maximum price query in alpha order' do 
      merchant = create(:merchant)

      llama = Item.create!(name: 'Llama', description: 'abc', unit_price: 5.0, merchant_id: merchant.id)
      dress = Item.create!(name: 'Dress', description: 'abc', unit_price: 20.0, merchant_id: merchant.id)
      ball = Item.create!(name: 'Ball', description: 'abc', unit_price: 10.0, merchant_id: merchant.id)
      bell = Item.create!(name: 'Bell', description: 'abc', unit_price: 15.0, merchant_id: merchant.id)

      expect(Item.max_price(10)).to eq([ball, llama])
    end

    it 'returns a list of Items matching a minimum AND maximum price query in alpha order' do 
      merchant = create(:merchant)

      llama = Item.create!(name: 'Llama', description: 'abc', unit_price: 40.0, merchant_id: merchant.id)
      ball = Item.create!(name: 'Ball', description: 'abc', unit_price: 50.0, merchant_id: merchant.id)
      dress = Item.create!(name: 'Dress', description: 'abc', unit_price: 65.0, merchant_id: merchant.id)
      bell = Item.create!(name: 'Bell', description: 'abc', unit_price: 75.0, merchant_id: merchant.id)

      expect(Item.min_max(50, 70)).to eq([ball, dress])
    end 
  end
end