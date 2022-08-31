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
  end

  describe 'class methods' do 
    it 'returns a list of Items matching a name query in alpha order' do 
      merchant = create(:merchant)

      llama = Item.create!(name: 'Llama', description: 'abc', unit_price: 5.0, merchant_id: merchant.id)
      ball = Item.create!(name: 'Ball', description: 'abc', unit_price: 5.0, merchant_id: merchant.id)
      bell = Item.create!(name: 'Bell', description: 'abc', unit_price: 5.0, merchant_id: merchant.id)
      dress = Item.create!(name: 'Dress', description: 'abc', unit_price: 5.0, merchant_id: merchant.id)

      expect(Item.find_matches('ll')).to eq([ball, bell, llama])
    end

    it 'returns a list of Items matching a minimum price query in alpha order' do 
      merchant = create(:merchant)

      llama = Item.create!(name: 'Llama', description: 'abc', unit_price: 5.0, merchant_id: merchant.id)
      dress = Item.create!(name: 'Dress', description: 'abc', unit_price: 20.0, merchant_id: merchant.id)
      ball = Item.create!(name: 'Ball', description: 'abc', unit_price: 10.0, merchant_id: merchant.id)
      bell = Item.create!(name: 'Bell', description: 'abc', unit_price: 15.0, merchant_id: merchant.id)

      expect(Item.min_price(10)).to eq([ball, bell, dress])
    end


  end
end