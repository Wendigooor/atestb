class CreateCampaignLocationPoints < ActiveRecord::Migration
  def change
    create_table :campaign_location_points do |t|

      t.timestamps
    end
    add_column :campaign_location_points, :latitude, :float, :default => 0.0
    add_column :campaign_location_points, :longitude, :float, :default => 0.0

    add_column :campaign_location_points, :address, :string, :default => ""
    add_column :campaign_location_points, :distance, :float, :default => 0.0
    add_column :campaign_location_points, :campaign_id, :integer
  end
end
