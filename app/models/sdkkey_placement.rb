class SdkkeyPlacement < ActiveRecord::Base
  attr_accessible :on, :placement_id, :sdkkey_id
  	belongs_to :placement
	belongs_to :sdkkey
end
