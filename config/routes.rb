Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :purposes, only: [:index]

      namespace :yards do
        get '/yard_search', to: 'search#search'
        get '/:id/bookings', to: 'bookings#index'
      end
      resources :yards, except: [:index] do
        # resources :bookings, only: [:index]
      end

      resources :bookings, only: [:show, :create, :update, :destroy]

      resources :hosts, only: [] do
        resources :yards, only: [:index]
      end

      namespace :renters do
        get '/:renter_id/bookings', to: 'bookings#index'
      end

      namespace :hosts do
        get '/:host_id/bookings', to: 'bookings#index'
      end
    end
  end
end
