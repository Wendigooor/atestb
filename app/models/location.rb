class Location < ActiveRecord::Base
 # attr_accessible :country, :state, :user_id
  belongs_to :user

  has_many :campaign_locations
  has_many :locations, :through => :campaign_locations

  has_one :user_location
  has_one :location, :through => :user_location

end
