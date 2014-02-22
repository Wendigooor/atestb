class AddDeveloperToClients < ActiveRecord::Migration
  def change
    add_column :clients, :developer, :boolean
  end
end
