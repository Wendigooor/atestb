class CreateCampaignStats < ActiveRecord::Migration
  def change
    create_table :campaign_stats do |t|

    	t.integer :campaign_id
    	t.integer :campaignItem_id
    	t.integer :click
      
    end
  end
end
