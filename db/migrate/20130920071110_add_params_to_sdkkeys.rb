class AddParamsToSdkkeys < ActiveRecord::Migration
  def change
  	add_column :sdkkeys, :name, :string
    add_column :sdkkeys, :active, :boolean, :default => true
    add_column :sdkkeys, :clicks, :integer, :default => 0
  end
end
