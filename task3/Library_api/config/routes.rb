Rails.application.routes.draw do
  #root "books#index"
  resources :books
  resources :publishers
  resources :categories
  #get "/authors", to: "authors#index"
  resources :authors
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
