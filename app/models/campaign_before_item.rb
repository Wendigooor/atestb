class CampaignBeforeItem < ActiveRecord::Base
 # attr_accessible :campaign_item_id, :campaign_id

  belongs_to :campaign_item
  belongs_to :campaign
end
