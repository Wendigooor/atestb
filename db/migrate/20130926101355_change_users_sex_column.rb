class ChangeUsersSexColumn < ActiveRecord::Migration
  def up
	change_column :users, :sex, :integer 
  end


  def down
  end
end
