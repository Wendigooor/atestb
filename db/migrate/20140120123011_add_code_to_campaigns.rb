class AddCodeToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :static_key, :string
  end
end
