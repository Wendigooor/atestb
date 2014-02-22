class AddMultipleToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :multiple, :boolean
  end
end
