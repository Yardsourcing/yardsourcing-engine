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
    if yard_purposes
      yard = Yard.create!(yard_params)
      create_yard_purposes(yard)
      render json: YardSerializer.new(yard), status: :created
    else
      error = "You must select at least one purpose"
      render_error(error, :not_acceptable)
    end
  end

  def update
    yard = Yard.find(params[:id])
    if yard_purposes
      yard.update!(yard_params)
      create_yard_purposes(yard)
      YardPurpose.destroy(yard.yard_purposes.find_unselected_purposes(yard_purposes))
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

  def create_yard_purposes(yard)
    yard_purposes&.each do |purpose|
      if yard.purposes.where(id: purpose).empty?
        YardPurpose.create!(yard_id: yard.id, purpose_id: purpose)
      end
    end
  end

  private

  def yard_purposes
    params[:yard][:purposes]
  end

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
