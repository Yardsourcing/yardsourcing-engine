Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :purposes, only: [:index]

      get '/yards/yard_search', to: 'yards/search#index'

      resources :yards, except: [:index]
      resources:bookings, only: [:show]

      resources :hosts, only: [] do
        resources :yards, only: [:index]
      end
    end
  end
end
