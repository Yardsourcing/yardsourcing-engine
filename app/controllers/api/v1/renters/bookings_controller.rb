class Api::V1::Renters::BookingsController < ApplicationController
  before_action :validate_params, only: :index

  def index
    renter_id = params[:renter_id]
    status = params[:status]
    bookings = Booking.find_by_renter_and_status(renter_id, status)
    if bookings.empty?
      render json: NullSerializer.new
    else
      render json: BookingSerializer.new(bookings)
    end
  end

  private
  def validate_params
    if params[:status].nil? || params[:status].empty?
      render json: {error: "Need status"}, status: :bad_request
    end
  end
end
