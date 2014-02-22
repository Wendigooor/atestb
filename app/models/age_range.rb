class AgeRange < ActiveRecord::Base
#  attr_accessible :age_left, :age_right, :index
  has_many :campaign_age_ranges
  has_many :campaigns, :through => :campaign_age_ranges

  def full_range
  	"#{age_left} - #{age_right}"
  end
end
