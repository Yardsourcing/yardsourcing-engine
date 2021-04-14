class Api::V1::YardsController < ApplicationController
  before_action :validate_params

  def show
    yard = Yard.where(id: params[:id])
    if yard.empty?
      render json: NullSerializer.new
    else
      render json: YardSerializer.new(Yard.find(params[:id]))
    end
  end

  private

  def validate_params
    if params[:id].to_i == 0
      render json: {error: "String not accepted as id"}, status: :bad_request
    end
  end
end
