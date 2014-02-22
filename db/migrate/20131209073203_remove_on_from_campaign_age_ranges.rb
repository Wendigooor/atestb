class RemoveOnFromCampaignAgeRanges < ActiveRecord::Migration
  def up
  	remove_column :campaign_age_ranges, :on 
  end

  def down
  end
end
