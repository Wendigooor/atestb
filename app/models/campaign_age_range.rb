class CampaignAgeRange < ActiveRecord::Base
  attr_accessible :age_range_id, :campaign_id
  belongs_to :age_range
  belongs_to :campaign
end
