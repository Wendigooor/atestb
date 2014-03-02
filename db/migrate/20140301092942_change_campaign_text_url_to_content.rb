class ChangeCampaignTextUrlToTextUrl < ActiveRecord::Migration
  def change
  	rename_column :campaign_items, :textUrl, :content
  end
end
