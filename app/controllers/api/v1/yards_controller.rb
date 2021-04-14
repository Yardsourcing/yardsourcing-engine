class Api::V1::YardsController < ApplicationController

  def show
    yard = Yard.where(id: params[:id])
    if yard.empty?
      render json: NullSerializer.new
    else
      render json: YardSerializer.new(yard)
    end
  end
end
