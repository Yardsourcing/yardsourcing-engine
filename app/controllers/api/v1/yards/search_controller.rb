class Api::V1::Yards::SearchController < ApplicationController
  before_action :validate_search_params, only: :index
  def index
    if params[:purposes]
      yards = Yard.yards_by_zipcode_and_purposes(params[:location], params[:purposes])
      render json: YardSerializer.new(yards)
    else
      yards = Yard.yards_by_zipcode(params[:location])
      render json: YardSerializer.new(yards)
    end
  end

  private

  def validate_search_params
    if !params[:location].scan(/\D./).empty? || params[:location].length != 5
      error = "Invalid zipcode"
      render_error(error)
    end
  end
end
