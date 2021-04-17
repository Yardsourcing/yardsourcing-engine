Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

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
