class Api::V1::Yards::SearchController < ApplicationController
  before_action :validate_search_params, only: :index
  def index
    yards = Yard.yards_by_zipcode(params[:location])
    render json: YardSerializer.new(yards)
  end

  private

  def validate_search_params
    if !params[:location].scan(/\D./).empty? || params[:location].length != 5
      error = "Invalid zipcode"
      render_error(error)
    end
  end
end
