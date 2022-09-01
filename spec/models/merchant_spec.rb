require 'rails_helper' 

RSpec.describe Merchant, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'relations' do 
    it { should have_many :items }
  end

  describe 'instance methods' do 
    it 'deletes the Merchant if it has no Items' do 
      merchant = create(:merchant)
      expect(Merchant.count).to eq 1 

      merchant.check_dependent_destroy 

      expect(Merchant.count).to eq 0 
      expect{Merchant.find(merchant.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'does not delete the Merchant if it has no Items' do 
      create_list(:merchant, 2)
      item = create(:item)
      merchant = item.merchant 

      expect(Merchant.count).to eq 3

      merchant.check_dependent_destroy 

      expect(Merchant.count).to eq 3 
    end
  end

  describe 'class methods' do 
    it 'returns a list of Merchants in alpha order based on a search' do 
      john = Merchant.create!(name: 'John Doe')
      joe = Merchant.create!(name: 'Joe Manchin')
      jolene = Merchant.create!(name: 'Jolene Smith')
      darrel = Merchant.create!(name: 'Darrel Farjo')
      priyanka = Merchant.create!(name: 'Priyanka Chopra')

      expect(Merchant.find_matches("Jo")).to eq [darrel, joe, john, jolene]
    end

    it 'returns a single Merchant from the search' do 
      john = Merchant.create!(name: 'John Doe')
      joe = Merchant.create!(name: 'Joe Manchin')
      jolene = Merchant.create!(name: 'Jolene Smith')
      darrel = Merchant.create!(name: 'Darrel Farjo')
      priyanka = Merchant.create!(name: 'Priyanka Chopra')

      expect(Merchant.find_merchant("Jo")).to eq darrel
    end
  end
end