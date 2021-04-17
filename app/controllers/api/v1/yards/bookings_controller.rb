module Api
  module V1
    module Yards
      class BookingsController < ApplicationController

        def index
          yard = Yard.find(params[:id])
          bookings = yard.bookings
          require "pry"; binding.pry
          if bookings.empty?
            render json: NullSerializer.new
          else
            render json: BookingSerializer.new(bookings)
          end
        end
      end
    end
  end
end
