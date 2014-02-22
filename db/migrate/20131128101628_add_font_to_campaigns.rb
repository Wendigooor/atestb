class AddFontToCampaigns < ActiveRecord::Migration
  def change
      add_column :campaigns, :font, :string
      add_column :campaigns, :font_size, :integer
  end
end
