class YardPurpose < ApplicationRecord
  belongs_to :yard
  belongs_to :purpose

  def self.find_unselected_purposes(new_purposes)
    # require "pry"; binding.pry
    where('purpose_id not in (?)', new_purposes)
    .pluck(:id)
  end
end
