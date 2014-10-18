Rails.application.routes.draw do
  resources :users
  root to: 'visitors#index'
  get '/real' => 'visitors#real'
  get '/auth/:provider/callback' => 'sessions#create'
  get '/signin' => 'sessions#new', :as => :signin
  get '/signout' => 'sessions#destroy', :as => :signout
  get '/auth/failure' => 'sessions#failure'
  get '/fax/receive' => 'webhooks#receive'
end
