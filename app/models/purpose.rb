class Purpose < ApplicationRecord
  has_many :yard_purposes, dependent: :destroy
  has_many :yards, through: :yard_purposes

  validates_presence_of :name

  before_save :downcase_name

  def downcase_name
    self.name = self.name.downcase
  end
end
