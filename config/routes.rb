Rails.application.routes.draw do
  resources :users
  if Rails.env.production?
    root to: 'visitors#placeholder'
    get '/real' => 'visitors#index'
  else
    root to: 'visitors#index'
  end

  resources :faxes

  get '/auth/:provider/callback' => 'sessions#create'
  get '/signin' => 'sessions#new', :as => :signin
  get '/signout' => 'sessions#destroy', :as => :signout
  get '/auth/failure' => 'sessions#failure'
  get '/fax/receive' => 'webhooks#receive'

  get '/help(/:action)', controller: 'help', as: 'help'

  match '/mail' => 'webhooks#inbound_mail', via: [:get, :post]
end
