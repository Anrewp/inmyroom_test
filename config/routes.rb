Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api, format: :json do
    namespace :v1 do
      resources :warehouses, only: :none do
        get :statistic, on: :member

        resources :products, only: :none do
          member do
            post :send_to_warehouse
            post :sell_product
          end
        end
      end
    end
  end
  
end
