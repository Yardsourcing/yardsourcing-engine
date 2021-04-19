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

  def update
    booking = Booking.find(params[:id])
    booking.update!(booking_params)
    render json: BookingSerializer.new(booking)
  end

  def destroy
    render json: Booking.destroy(params[:id])
  end

  private
  def validate_params
    if params[:id].to_i == 0
      render json: {error: "String not accepted as id"}, status: :bad_request
    end
  end

  def booking_params
    params.require(:booking).permit(:yard_id, :renter_email, :renter_id, :status, :booking_name, :date, :time, :duration, :description)
  end
end
