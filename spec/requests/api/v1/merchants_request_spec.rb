require 'rails_helper'

describe 'Merchants API' do 
  it 'sends a list of Merchants' do 
    create_list(:merchant, 3)

    get '/api/v1/merchants' 

    expect(response).to be_successful 

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants).to be_a Hash
    expect(merchants[:data]).to be_an Array 

    expect(merchants[:data].count).to eq 3 

    merchants[:data].each do |merchant| 
      expect(merchant).to have_key(:id) 
      expect(merchant[:id]).to be_a String  

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a String 
    end
  end

  it 'can get one Merchant by its id' do 
    id = create(:merchant).id 

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful 

    merchant_data = merchant[:data]

    expect(merchant_data).to have_key(:id) 
    expect(merchant_data[:id]).to eq id.to_s
    expect(merchant_data[:id]).to be_a String 

    expect(merchant[:data][:attributes]).to have_key(:name)
    expect(merchant_data[:attributes][:name]).to be_a String 
  end

  it 'returns an error if item does not exist for show' do 
    create_list(:merchant, 5)
    id = Merchant.last.id + 1000

    get "/api/v1/merchants/#{id}"

    item = JSON.parse(response.body, symbolize_names: true)

    expect(response).to have_http_status(404)
  end
end