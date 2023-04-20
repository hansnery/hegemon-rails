Rails.application.routes.draw do
  resources :games do
    resources :maps do
      resources :players
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "games#index"
  get 'provinces', to: 'provinces#index', defaults: { format: 'json' }
  get '/games/:game_id/maps/:id/:province_1_id/marches_to/:province_2_id/:num_armies', to: 'maps#marches_to'
end
