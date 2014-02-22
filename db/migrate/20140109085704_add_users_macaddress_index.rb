class AddUsersMacaddressIndex < ActiveRecord::Migration
  def up
	add_index(:users,  :macaddress)
  end

  def down
  end
end
