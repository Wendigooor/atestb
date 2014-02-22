class AddClicksCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :clicks_count, :integer
  end
end
