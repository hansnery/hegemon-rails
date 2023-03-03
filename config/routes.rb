Rails.application.routes.draw do
  resources :players
  resources :maps
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "maps#index"
  get 'provinces', to: 'provinces#index', defaults: { format: 'json' }
  get '/maps/:id/:province_1_id/marches_to/:province_2_id/:num_armies', to: 'maps#marches_to'
end
