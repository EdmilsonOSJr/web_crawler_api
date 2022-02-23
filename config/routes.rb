Rails.application.routes.draw do
  resources :quotes
  resources :tags
  #resources :quotes
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '/quotes/:tag', to: 'quotes#search_quotes'
  get '/quotes',to: 'quotes#index'

end
