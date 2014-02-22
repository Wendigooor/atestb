class AddDefaultValueForTargetDevice < ActiveRecord::Migration
  def up
  	change_column :campaigns, :target_device, :integer, :default => 2
  end

  def down
  end
end
