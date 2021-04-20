class Api::V1::Renters::BookingsController < ApplicationController
  before_action :validate_status, only: :index
  before_action :validate_id, only: :index

  def index
    renter_id = params[:renter_id]
    status = params[:status]
    bookings = if status
                  Booking.find_by_renter_and_status(renter_id, status).page params[:page]
                else
                  Booking.find_by_renter(renter_id).page params[:page]
                end
    if bookings.empty?
      render json: NullSerializer.new
    else
      render json: BookingSerializer.new(bookings)
    end
  end
end
