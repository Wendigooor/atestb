class CreateCampaignBeforeAnswers < ActiveRecord::Migration
	def change
    	create_table :campaign_before_items do |t|
			t.integer :campaign_id
			t.integer :campaign_item_id

			t.timestamps
		end
  	end	
end
