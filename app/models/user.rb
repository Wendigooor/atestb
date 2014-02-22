class User < ActiveRecord::Base
  attr_accessible :macaddress, :latitude, :longitude, :sex, :location_id, :build_version, :country, :age_range_id
  has_many :clicks
  has_many :impressions

  has_one :user_location, :dependent => :destroy
  has_one :location, :through => :user_location, :dependent => :destroy

  geocoded_by :location

  belongs_to :age_range
end