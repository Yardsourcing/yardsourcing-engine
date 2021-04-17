class Api::V1::Yards::BookingsController < ApplicationController
  before_action :validate_params, only: :index

  def index
    yard = Yard.find(params[:id])
    bookings = yard.bookings.page params[:page]
    if bookings.empty?
      render json: NullSerializer.new
    else
      render json: BookingSerializer.new(bookings)
    end
  end

  private
  def validate_params
    if params[:id].to_i == 0
      render json: {error: "String not accepted as id"}, status: :bad_request
    end
  end
end
