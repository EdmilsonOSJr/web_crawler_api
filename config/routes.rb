Rails.application.routes.draw do
  #resources :quotes
  #resources :tags
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :auths, only: [:create]
  
  get '/quotes/:tag', to: 'quotes#search_quotes'
  get '/quotes',to: 'quotes#index'

end
