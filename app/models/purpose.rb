class Purpose < ApplicationRecord
  has_many :yard_purposes, dependent: :destroy
  has_many :yards, through: :yard_purposes

  validates_presence_of :name
end
