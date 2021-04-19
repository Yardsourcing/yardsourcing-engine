class Api::V1::Hosts::BookingsController < ApplicationController
  before_action :validate_status, only: :index
  before_action :validate_host_id, only: :index

  def index
    host_id = params[:host_id]
    status = params[:status]
    bookings = if status
                  Booking.find_by_host_and_status(host_id, status).page params[:page]
                else
                  Booking.find_by_host(host_id).page params[:page]
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
      error = "Need status"
      render_error(error)
    end
  end

  def validate_host_id
    if params[:host_id].to_i == 0
      error = "String not accepted as id"
      render_error(error)
    end
  end
end
