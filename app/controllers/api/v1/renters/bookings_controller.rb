class Api::V1::Renters::BookingsController < ApplicationController
  before_action :validate_status, only: :index
  before_action :validate_renter_id, only: :index

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

  private

  def validate_status
    if !params[:status].nil? && params[:status].empty?
      render json: {error: "Need status"}, status: :bad_request
    end
  end

  def validate_renter_id
    if params[:renter_id].to_i == 0
      render json: {error: "String not accepted as id"}, status: :bad_request
    end
  end
end
