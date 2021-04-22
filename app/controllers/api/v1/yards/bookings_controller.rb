class Api::V1::Yards::BookingsController < ApplicationController
  before_action :validate_id, only: :index

  def index
    yard = Yard.find(params[:id])
    bookings = yard.bookings.page params[:page]
    return render json: NullSerializer.new if bookings.empty?
    render json: BookingSerializer.new(bookings)
  end
end
