class Impression < ActiveRecord::Base
  attr_accessible :campaign_id, :sdkkey, :user_id
  belongs_to :user
end
