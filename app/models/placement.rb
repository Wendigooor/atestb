class Placement < ActiveRecord::Base
  attr_accessible :name, :point
  has_many :campaign_placements
  has_many :campaigns, :through => :campaign_placements
end
