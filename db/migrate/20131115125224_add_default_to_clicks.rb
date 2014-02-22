class AddDefaultToClicks < ActiveRecord::Migration
  def change
	change_column :users, :clicks_count, :integer, :default => 0  
end
end
