class Api::V1::PurposesController < ApplicationController

  def index
    purposes = Purpose.all.page params[:page]
    return render json: NullSerializer.new if purposes.empty?
    render json: PurposeSerializer.new(purposes)
  end
end
