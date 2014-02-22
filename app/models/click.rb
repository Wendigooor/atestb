class Click < ActiveRecord::Base
 # attr_accessible :date, :sdkkey, :campaign_id, :answer_id, :user_id
  belongs_to :user
end
