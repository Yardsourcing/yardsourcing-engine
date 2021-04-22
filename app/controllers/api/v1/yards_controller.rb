class Api::V1::YardsController < ApplicationController
  before_action :validate_id, only: [:index, :show]

  def index
    yards = YardsFacade.find_yards(params[:host_id], params[:page])
    render json: YardSerializer.new(yards)
  end

  def show
    yard = Yard.where(id: params[:id])
    return render json: NullSerializer.new if yard.empty?
    render json: YardSerializer.new(Yard.find(params[:id]))
  end

  def create
    yard = YardsFacade.create_yard(yard_params, params[:purposes])
    return render_error(yard[:error], :not_acceptable) if yard[:error]
    render json: YardSerializer.new(yard), status: :created
  end

  def update
    yard = YardsFacade.update_yard(params[:id], yard_params, params[:purposes])
    return render_error(yard[:error], :not_acceptable) if yard[:error]
    render json: YardSerializer.new(yard)
  end

  def destroy
    yard = Yard.find(params[:id])
    if yard.bookings.active_bookings.count > 0
      return render_error("Can't delete a yard with active bookings", :not_acceptable)
    end
    render json: Yard.destroy(params[:id])
  end

  private

  def yard_params
    params.permit(:host_id,
                  :email,
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
