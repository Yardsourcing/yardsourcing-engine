class YardPurpose < ApplicationRecord
  belongs_to :yard
  belongs_to :purpose
  validates_presence_of :purpose_id, :yard_id

  validates_uniqueness_of :purpose_id, scope: :yard_id

  def self.find_unselected_purposes(new_purposes)
    where('purpose_id not in (?)', new_purposes)
    .pluck(:id)
  end
end
