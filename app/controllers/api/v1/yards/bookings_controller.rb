class Api::V1::Yards::BookingsController < ApplicationController
  before_action :validate_id, only: :index

  def index
    yard = Yard.find(params[:id])
    bookings = yard.bookings.page params[:page]
    if bookings.empty?
      render json: NullSerializer.new
    else
      render json: BookingSerializer.new(bookings)
    end
  end
end
