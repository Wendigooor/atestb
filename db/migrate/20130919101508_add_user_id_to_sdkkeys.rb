class AddUserIdToSdkkeys < ActiveRecord::Migration
  def change
    add_column :sdkkeys, :client_id, :integer
  end
end
