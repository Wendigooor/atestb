class AddBuildVersionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :build_version, :string
  end
end
