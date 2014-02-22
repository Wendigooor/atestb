class AddOnToCampaignPlacements < ActiveRecord::Migration
  def change
    add_column :campaign_placements, :on, :boolean, :default => true
  end
end
