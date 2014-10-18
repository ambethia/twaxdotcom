Rails.application.routes.draw do
  resources :users

  if Rails.env.production?
    root to: 'visitors#placeholder'
  else
    root to: 'visitors#index'
  end

  get '/real' => 'visitors#index'
  get '/auth/:provider/callback' => 'sessions#create'
  get '/signin' => 'sessions#new', :as => :signin
  get '/signout' => 'sessions#destroy', :as => :signout
  get '/auth/failure' => 'sessions#failure'
  get '/fax/receive' => 'webhooks#receive'
end
