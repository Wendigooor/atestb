class AddCampaignIdToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :campaign_id, :integer
  end
end
