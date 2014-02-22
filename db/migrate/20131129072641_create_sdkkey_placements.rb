class CreateSdkkeyPlacements < ActiveRecord::Migration
  def change
    create_table :sdkkey_placements do |t|
      t.integer :sdkkey_id
      t.integer :placement_id
      t.boolean :on, :default => true

      t.timestamps
    end

    drop_table :campaign_placements
  end
end
