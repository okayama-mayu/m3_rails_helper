require 'rails_helper' 

RSpec.describe 'Items API' do 
  it 'sends a list of all Items' do 
    create_list(:item, 5)

    get '/api/v1/items' 

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    items_data = items[:data]

    expect(items_data.count).to eq 5 

    items_data.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a String 

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a String 

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a String 

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a Float

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_an Integer
    end 
  end

  it 'gets one item' do 
    id = create(:item).id 

    get "/api/v1/items/#{id}"

    item = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    item_data = item[:data]
    item_attributes = item[:data][:attributes]

    expect(item_data).to have_key(:id)
    expect(item_data[:id]).to be_a String 

    expect(item_attributes).to have_key(:name)
    expect(item_attributes[:name]).to be_a String 

    expect(item_attributes).to have_key(:description)
    expect(item_attributes[:description]).to be_a String 

    expect(item_attributes).to have_key(:unit_price)
    expect(item_attributes[:unit_price]).to be_a Float

    expect(item_attributes).to have_key(:merchant_id)
    expect(item_attributes[:merchant_id]).to be_an Integer
  end

  it 'returns an error if item does not exist for show' do 
    create_list(:item, 5)
    id = Item.last.id + 1000

    get "/api/v1/items/#{id}"

    item = JSON.parse(response.body, symbolize_names: true)

    expect(response).to have_http_status(404)
  end

  it 'creates an Item' do 
    merchant_id = create(:merchant).id 
    
    item_params = ({
                    name: Faker::Device.model_name, 
                    description: Faker::Lorem.sentence, 
                    unit_price: Faker::Commerce.price, 
                    merchant_id: merchant_id
                  })
    headers = { "CONTENT_TYPE" => "application/json" }

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

    created_item = Item.last 

    expect(response).to be_successful
    expect(created_item.name).to eq item_params[:name]
    expect(created_item.description).to eq item_params[:description]
    expect(created_item.unit_price).to eq item_params[:unit_price]
  end

  it 'returns an error if Item is not properly created' do 
    merchant_id = create(:merchant).id 
    
    item_params = ({
                    name: '', 
                    description: Faker::Lorem.sentence, 
                    unit_price: Faker::Commerce.price, 
                    merchant_id: merchant_id
                  })
    headers = { "CONTENT_TYPE" => "application/json" }

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

    expect(response).to have_http_status(404)
  end

  it 'edits an Item' do 
    id = create(:item).id 
    previous_name = Item.last.name 
    item_params = { name: 'iPhone 20' }
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
    item = Item.find_by(id: id)

    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq(item_params[:name])
  end

  it 'returns an error code if edit is not successful' do 
    id = create(:item).id 
    previous_name = Item.last.name 
    item_params = { name: '' }
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})

    expect(response).to have_http_status(404)
  end

  it 'deletes an Item' do 
    item = create(:item)

    merchant = item.merchant 

    expect(Item.count).to eq(1) 

    delete "/api/v1/items/#{item.id}"

    expect(response).to have_http_status(204)
    expect(response).to be_successful
    expect(Item.count).to eq 0 
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    expect{Merchant.find(merchant.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'returns a Merchant given Item ID' do 
    item = create(:item) 
    merchant = item.merchant 

    get "/api/v1/items/#{item.id}/merchant"

    expect(response).to be_successful

    merchant_info = JSON.parse(response.body, symbolize_names: true)

    merchant_data = merchant_info[:data]

    expect(merchant_data).to have_key(:id) 
    expect(merchant_data[:id]).to eq merchant.id.to_s

    expect(merchant_data[:attributes]).to have_key(:name)
    expect(merchant_data[:attributes][:name]).to eq merchant.name 
  end

  it 'returns a 404 if the Item is not found' do 
    item = create(:item) 

    get "/api/v1/items/#{item.id + 50}/merchant"

    expect(response).to have_http_status(404)
  end

  it 'searches for all items matching the name' do 
    merchant = create(:merchant)

    llama = Item.create!(name: 'Llama', description: 'abc', unit_price: 5.0, merchant_id: merchant.id)
    ball = Item.create!(name: 'Ball', description: 'abc', unit_price: 5.0, merchant_id: merchant.id)
    bell = Item.create!(name: 'Bell', description: 'abc', unit_price: 5.0, merchant_id: merchant.id)
    dress = Item.create!(name: 'Dress', description: 'abc', unit_price: 5.0, merchant_id: merchant.id)

    get "/api/v1/items/find_all?name=ll"
    
    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq 3
    
    expect(items[:data][0][:attributes][:name]).to eq 'Ball'
    expect(items[:data][1][:attributes][:name]).to eq 'Bell'
    expect(items[:data][2][:attributes][:name]).to eq 'Llama'
  end

  it 'returns an empty hash for the data if no items match the name query' do 
    merchant = create(:merchant)

    llama = Item.create!(name: 'Llama', description: 'abc', unit_price: 5.0, merchant_id: merchant.id)
    ball = Item.create!(name: 'Ball', description: 'abc', unit_price: 5.0, merchant_id: merchant.id)
    bell = Item.create!(name: 'Bell', description: 'abc', unit_price: 5.0, merchant_id: merchant.id)
    dress = Item.create!(name: 'Dress', description: 'abc', unit_price: 5.0, merchant_id: merchant.id)

    get "/api/v1/items/find_all?name=nomatch"
    
    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data]).to eq({})
  end

  it 'searches for all items matching the minimum price' do 
    merchant = create(:merchant)

    llama = Item.create!(name: 'Llama', description: 'abc', unit_price: 35.0, merchant_id: merchant.id)
    ball = Item.create!(name: 'Ball', description: 'abc', unit_price: 45.0, merchant_id: merchant.id)
    dress = Item.create!(name: 'Dress', description: 'abc', unit_price: 65.0, merchant_id: merchant.id)
    bell = Item.create!(name: 'Bell', description: 'abc', unit_price: 55.0, merchant_id: merchant.id)
    

    get "/api/v1/items/find_all?min_price=50"
    
    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq 2
    
    expect(items[:data][0][:attributes][:name]).to eq 'Bell'
    expect(items[:data][1][:attributes][:name]).to eq 'Dress'
  end

  it 'returns empty hash if min price does not match any Items' do 
    merchant = create(:merchant)

    llama = Item.create!(name: 'Llama', description: 'abc', unit_price: 35.0, merchant_id: merchant.id)
    ball = Item.create!(name: 'Ball', description: 'abc', unit_price: 45.0, merchant_id: merchant.id)
    dress = Item.create!(name: 'Dress', description: 'abc', unit_price: 65.0, merchant_id: merchant.id)
    bell = Item.create!(name: 'Bell', description: 'abc', unit_price: 55.0, merchant_id: merchant.id)

    get "/api/v1/items/find_all?min_price=100"
    
    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data]).to eq({})
  end

  it 'searches for all Items matching max price' do 
    merchant = create(:merchant)

    llama = Item.create!(name: 'Llama', description: 'abc', unit_price: 35.0, merchant_id: merchant.id)
    ball = Item.create!(name: 'Ball', description: 'abc', unit_price: 45.0, merchant_id: merchant.id)
    dress = Item.create!(name: 'Dress', description: 'abc', unit_price: 65.0, merchant_id: merchant.id)
    bell = Item.create!(name: 'Bell', description: 'abc', unit_price: 55.0, merchant_id: merchant.id)
    

    get "/api/v1/items/find_all?max_price=50"
    
    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq 2
    
    expect(items[:data][0][:attributes][:name]).to eq 'Ball'
    expect(items[:data][1][:attributes][:name]).to eq 'Llama'
  end
end