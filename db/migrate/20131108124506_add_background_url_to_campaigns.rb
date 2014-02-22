class AddBackgroundUrlToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :background_url, :string
  end
end
