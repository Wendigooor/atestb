class CreateCampaignLocations < ActiveRecord::Migration
  def change
    create_table :campaign_locations do |t|
      t.integer :campaign_id
      t.integer :location_id

      t.timestamps
    end

    create_table :user_locations do |t|
      t.integer :user_id
      t.integer :location_id

      t.timestamps
    end

    remove_column :locations, :user_id
    remove_column :locations, :campaign_id
  end
end
