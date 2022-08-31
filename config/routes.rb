Rails.application.routes.draw do
  get "api/v1/merchants/find", to: 'api/v1/merchants/search#show'
  
  namespace :api do 
    namespace :v1 do 
      resources :merchants, only: [:index, :show] do 
        resources :items, only: [:index], :controller => 'merchant_items'
        # resources :search, only: [:show], :controller => 'search'
      end
      
      resources :items, only: [:index, :show, :create, :update, :destroy] do 
        resources :merchant, only: [:index], :controller => 'item_merchant' 
      end
    end
  end
end
