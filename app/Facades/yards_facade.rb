class YardsFacade
  def self.find_yards(host_id, page)
    Yard.where(host_id: host_id).page page
  end

  def self.create_yard(yard_params, purposes)
    error_message = "You must select at least one purpose"
    return OpenStruct.new({error: error_message}) unless purposes
    yard = Yard.create!(yard_params)
    create_yard_purposes(yard, purposes)
    yard
  end

  def self.update_yard(id, yard_params, purposes)
    yard = Yard.find(id)
    error_message = "You must select at least one purpose"
    return OpenStruct.new({error: error_message}) unless purposes
    yard.update!(yard_params)
    create_yard_purposes(yard, purposes)
    YardPurpose.destroy(yard.yard_purposes.find_unselected_purposes(purposes))
    yard
  end

  def self.create_yard_purposes(yard, purposes)
    purposes.each do |purpose_id|
      YardPurpose.create(yard_id: yard.id, purpose_id: purpose_id)
    end
  end
end
