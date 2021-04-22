class Api::V1::Yards::SearchController < ApplicationController
  before_action :validate_search_params, only: :search

  def search
    yards = YardsSearchFacade.make_search(params)
    render json: YardSerializer.new(yards)
  end

  private

  def validate_search_params
    if params[:location].nil?
      error = "Please enter a zipcode to search available yards"
      render_error(error)
    elsif !params[:location].scan(/\D./).empty? || params[:location].length != 5
      error = "Invalid zipcode"
      render_error(error)
    end
  end
end
