class AddUserIndexes < ActiveRecord::Migration
  def up
  	
  	add_index(:clicks, :user_id)
  	add_index(:users,  :created_at)
end

  def down
  end
end
