class Sdkkey < ActiveRecord::Base
  attr_accessible :key, :name, :clicks, :active, :placements_attributes, :sdkkey_placements_attributes

  validates :name, :uniqueness => true

  belongs_to :client

  has_many :sdkkey_placements
  has_many :placements, :through => :sdkkey_placements
  accepts_nested_attributes_for :placements
  accepts_nested_attributes_for :sdkkey_placements
end
