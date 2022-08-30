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

    expect(item).to have_key(:id)
    expect(item[:id]).to be_an Integer 

    expect(item).to have_key(:name)
    expect(item[:name]).to be_a String 

    expect(item).to have_key(:description)
    expect(item[:description]).to be_a String 

    expect(item).to have_key(:unit_price)
    expect(item[:unit_price]).to be_a Float

    expect(item).to have_key(:merchant_id)
    expect(item[:merchant_id]).to be_an Integer
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
end