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
    if params[:yard][:purposes]
      yard = Yard.create!(yard_params)
      params[:yard][:purposes].each do |purpose|
        YardPurpose.create!(yard_id: yard.id, purpose_id: purpose)
      end
      render json: YardSerializer.new(yard), status: :created
    else
      error = "You must select at least one purpose"
      render_error(error, :not_acceptable)
    end
  end

  def update
    yard = Yard.find(params[:id])
    if params[:yard][:purposes] || yard.purposes
      yard.update!(yard_params)
      params[:yard][:purposes]&.each do |purpose|
        binding.pry
        if yard.purposes.where(id: purpose).empty?
          YardPurpose.create!(yard_id: yard.id, purpose_id: purpose)
        end
      end
      render json: YardSerializer.new(yard)
    else
      error = "You must select at least one purpose"
      render_error(error, :not_acceptable)
    end
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
                                :photo_url_3,)
  end
end
