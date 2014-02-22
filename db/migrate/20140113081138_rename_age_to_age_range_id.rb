class RenameAgeToAgeRangeId < ActiveRecord::Migration
  def up
  	rename_column :users, :age, :age_range_id
  end

  def down
  end
end
