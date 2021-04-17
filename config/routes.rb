Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :purposes, only: [:index]

      get '/yards/yard_search', to: 'yards/search#index'
      get '/yards/:id/bookings', to: 'yards/bookings#index'
      resources :yards, except: [:index] do
        # resources :bookings, only: [:index]
        end
      resources :bookings, only: [:show]

      resources :hosts, only: [] do
        resources :yards, only: [:index]
      end

      namespace :renters do
        get '/:renter_id/bookings', to: 'bookings#index'
      end
    end
  end
end
