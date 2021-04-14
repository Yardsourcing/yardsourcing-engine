class Api::V1::YardsController < ApplicationController
  before_action :validate_params, only: :show

  def show
    yard = Yard.where(id: params[:id])
    if yard.empty?
      render json: NullSerializer.new
    else
      render json: YardSerializer.new(Yard.find(params[:id]))
    end
  end

  def create
    yard = Yard.create!(yard_params)
    render json: YardSerializer.new(yard), status: :created
  end

  def update
    yard = Yard.find(params[:id])
    yard.update!(yard_params)
    render json: YardSerializer.new(yard)
  end

  def destroy
    yard = Yard.find(params[:id])
    render json: Yard.destroy(params[:id])
  end

  private

  def validate_params
    if params[:id].to_i == 0
      render json: {error: "String not accepted as id"}, status: :bad_request
    end
  end

  def yard_params
  params.require(:yard).permit(:host_id,
                              :name,
                              :street_address,
                              :city,
                              :state,
                              :zipcode,
                              :price,
                              :description,
                              :availability,
                              :payment,
                              :photo_url_1,
                              :photo_url_2,
                              :photo_url_3)
end
end
