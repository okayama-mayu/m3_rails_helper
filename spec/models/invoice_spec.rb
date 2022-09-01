require 'rails_helper' 

RSpec.describe Invoice, type: :model do 
  describe 'relationships' do 
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items) }
    it { should belong_to :customer }
  end

  describe 'instance method' do 
    it 'deletes the Invoice if it has no Items' do 
      customer = Customer.create!(first_name: 'Carlos', last_name: 'Stich')
      merchant = create(:merchant)
      invoice = Invoice.create!(customer_id: customer.id, merchant_id: merchant.id, status: 'pending')

      invoice.check_dependent_destroy 

      expect(Invoice.count).to eq 0 
      expect{Invoice.find(invoice.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end

    xit 'does not delete the Invoice if it has an Item' do 

    end
  end
end