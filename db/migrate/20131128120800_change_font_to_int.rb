class ChangeFontToInt < ActiveRecord::Migration
  def up
  	change_column :campaigns, :font, :integer
  end

  def down
  end
end
