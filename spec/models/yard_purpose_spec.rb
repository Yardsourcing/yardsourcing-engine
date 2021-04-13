require 'rails_helper'

RSpec.describe YardPurpose, type: :model do
  describe 'relationships' do
    it { should belong_to :yard }
    it { should belong_to :purpose }
  end
end
