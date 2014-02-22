class AdvPeriod < ActiveRecord::Base
 # attr_accessible :campaign_id, :day, :end, :start

  belongs_to :campaign
end
