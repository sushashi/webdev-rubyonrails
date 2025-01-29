Rails.application.routes.draw do
  resources :styles
  resources :memberships
  resources :beerclubs
  resources :users do
    post 'toggle_account_status', on: :member
  end
  resources :beers
  resources :breweries do
    post 'toggle_activity', on: :member
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  root 'breweries#index'

  get 'all_beers', to: 'beers#index'
  # get 'beers/new', to: 'beers#new'

  # get 'ratings', to: 'ratings#index'
  # get 'ratings/new', to: 'ratings#new'
  # post 'ratings', to: 'ratings#create'

  resources :ratings, only: [:index, :new, :create, :destroy]

  get 'signup', to: 'users#new'
  get 'signin', to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'
  
  resource :session, only: [:new, :create, :destroy]

  resources :places, only: [:index, :show]

  get 'places', to: 'places#index'
  post 'places', to: 'places#search'

  get 'places/:id', to: 'places#show'
  delete 'memberships', to: 'memberships#destroy'

  get 'beerlist', to: 'beers#list'
  get 'brewerylist', to: 'breweries#list'
end
