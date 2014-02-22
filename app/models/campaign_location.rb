class CampaignLocation < ActiveRecord::Base
  #attr_accessible :campaign_id, :location_id

  belongs_to :location
  belongs_to :user
end
