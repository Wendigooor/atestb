class AddUserIdToClicks < ActiveRecord::Migration
  def change
    add_column :clicks, :user_id, :integer
  end
end
