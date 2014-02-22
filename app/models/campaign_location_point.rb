class CampaignLocationPoint < ActiveRecord::Base
  #attr_accessible :campaign_id, :latitude, :longitude, :distance, :address

  belongs_to :campaign
end
