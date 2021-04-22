class Api::V1::Hosts::BookingsController < ApplicationController
  before_action :validate_status, only: :index
  before_action :validate_id, only: :index

  def index
    host_id = params[:host_id]
    status = params[:status]
    bookings = if status
                  Booking.find_by_host_and_status(host_id, status).page params[:page]
                else
                  Booking.find_by_host(host_id).page params[:page]
                end
    return render json: NullSerializer.new if bookings.empty?
    render json: BookingSerializer.new(bookings)
  end
end
