class AddCountryColumnToUsers < ActiveRecord::Migration
  def up
  	add_column :users, :country, :string
  end

  def down
  end
end
