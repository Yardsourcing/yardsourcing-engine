class YardPurpose < ApplicationRecord
  belongs_to :yard
  belongs_to :purpose

  def self.find_unseleted_purposes(new_purposes)
    where('purpose_id not in (?)', new_purposes)
    .pluck(:id)
  end
end
