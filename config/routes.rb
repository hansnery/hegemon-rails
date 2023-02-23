Rails.application.routes.draw do
  resources :maps
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "maps#index"
  get 'provinces', to: 'provinces#index', defaults: { format: 'json' }
  # get 'provinces', to: 'provinces#show', defaults: { format: 'json' }
end
