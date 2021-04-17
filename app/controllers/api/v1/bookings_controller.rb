class Api::V1::BookingsController < ApplicationController
  before_action :validate_params, only: :show

  def show
    booking = Booking.find(params[:id])
    render json: BookingSerializer.new(booking)
  end

  def create
    booking = Booking.create!(booking_params)
    render json: BookingSerializer.new(booking), status: :created
  end

  private
  def validate_params
    if params[:id].to_i == 0
      render json: {error: "String not accepted as id"}, status: :bad_request
    end
  end

  def booking_params
    params.require(:booking).permit(:yard_id, :renter_id, :status, :booking_name, :date, :time, :duration, :description)
  end
end
