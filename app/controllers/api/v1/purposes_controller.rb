module Api
  module V1
    class PurposesController < ApplicationController

      def index
        purposes = Purpose.all
        if purposes.empty?
          render json: NullSerializer.new
        else
          render json: PurposeSerializer.new(purposes)
        end
      end 
    end
  end
end
