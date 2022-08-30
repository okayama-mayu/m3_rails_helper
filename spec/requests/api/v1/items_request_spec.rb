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
end