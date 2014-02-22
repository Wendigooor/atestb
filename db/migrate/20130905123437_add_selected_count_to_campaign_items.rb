class AddSelectedCountToCampaignItems < ActiveRecord::Migration
  def change
    add_column :campaign_items, :selected_count, :integer, :default => 0
  end
end
