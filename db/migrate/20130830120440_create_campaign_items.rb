class CreateCampaignItems < ActiveRecord::Migration
  def change
    create_table :campaign_items do |t|

      t.integer :campaign_id
      t.string :textUrl
      
    end
  end
end
