class YardsSearchFacade

  def self.make_search(params)
    return Yard.by_zipcode_and_purposes(params[:location], params[:purposes]).page params[:page] if params[:purposes]
    Yard.by_zipcode(params[:location]).page params[:page]
  end
end
