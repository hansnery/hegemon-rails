Rails.application.routes.draw do
  resources :maps
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "maps#index"
end
