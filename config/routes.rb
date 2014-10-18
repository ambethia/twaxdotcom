Rails.application.routes.draw do
  resources :users
  if Rails.env.production?
    root to: 'visitors#placeholder'
    get '/real' => 'visitors#index'
  else
    root to: 'visitors#index'
  end

  %i(real help help_left help_right).each do |action|
    get "/#{action}" => "visitors##{action}"
  end

  get '/auth/:provider/callback' => 'sessions#create'
  get '/signin' => 'sessions#new', :as => :signin
  get '/signout' => 'sessions#destroy', :as => :signout
  get '/auth/failure' => 'sessions#failure'
  get '/fax/receive' => 'webhooks#receive'

  match '/mail' => 'webhooks#inbound_mail', via: [:get, :post]
end
