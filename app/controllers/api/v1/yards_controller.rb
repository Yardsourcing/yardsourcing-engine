class Api::V1::YardsController < ApplicationController

  def show
    render json: YardSerializer.new(Yard.find(params[:id]))
  end
end
