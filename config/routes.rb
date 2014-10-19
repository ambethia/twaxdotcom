Rails.application.routes.draw do
  resources :users

  root to: 'visitors#index'

  resources :faxes, path: 'twaxes'

  get '/auth/:provider/callback' => 'sessions#create'
  get '/signin' => 'sessions#new', :as => :signin
  get '/signout' => 'sessions#destroy', :as => :signout
  get '/auth/failure' => 'sessions#failure'
  post '/fax/receive' => 'webhooks#receive'

  get '/help(/:action)', controller: 'help', as: 'help'

  get '/index' => 'visitors#index'

  get '/secret/emails' => 'email#index', as: 'emails'
  get '/secret/emails/:id' => 'email#show', as: 'email'

  match '/mail' => 'webhooks#inbound_mail', via: [:get, :post]
end
