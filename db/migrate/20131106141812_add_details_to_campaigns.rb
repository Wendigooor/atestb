class AddDetailsToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :border_color, :string
    add_column :campaigns, :title_color, :string
  end
end
