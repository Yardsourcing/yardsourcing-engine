Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :purposes, only: [:index]

      namespace :yards do
        get '/yard_search', to: 'search#search'
        get '/:id/bookings', to: 'bookings#index'
      end

      resources :yards, except: [:index]

      resources :bookings, only: [:show, :create, :update, :destroy]

      resources :hosts, only: [] do
        resources :yards, only: :index
        resources :bookings, controller: "hosts/bookings", only: :index
      end

      resources :renters , only: [] do
        resources :bookings, controller: "renters/bookings", only: :index
      end
    end
  end
end
