class Api::V1::BookingsController < ApplicationController
  before_action :validate_id, only: :show

  def show
    booking = Booking.find(params[:id])
    render json: BookingSerializer.new(booking)
  end

  def create
    booking = Booking.new(booking_params)
    if booking.save!
      EmailService.new_booking(booking.id)
      render json: BookingSerializer.new(booking), status: :created
    end
  end

  def update
    booking = Booking.find(params[:id])
    booking.update!(booking_params)
    EmailService.update_booking(booking.id, booking.status) unless booking.pending?
    render json: BookingSerializer.new(booking)
  end

  def destroy
    render json: Booking.destroy(params[:id])
  end

  private

  def booking_params
    params.permit(:yard_id, :renter_email, :renter_id, :status, :booking_name, :date, :time, :duration, :description)
  end
end
