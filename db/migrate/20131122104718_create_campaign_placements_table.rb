class CreateCampaignPlacementsTable < ActiveRecord::Migration
  def up

	create_table 'campaign_placements' do |t|
	    t.column :campaign_id, :integer
	    t.column :placement_id, :integer
	end
  end

  def down
  end
end
