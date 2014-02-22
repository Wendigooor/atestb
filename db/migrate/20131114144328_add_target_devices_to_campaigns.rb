class AddTargetDevicesToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :target_device, :integer
  end
end
