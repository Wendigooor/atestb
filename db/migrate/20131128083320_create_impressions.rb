class CreateImpressions < ActiveRecord::Migration
  def change
    create_table :impressions do |t|
      t.integer :user_id
      t.string :sdkkey
      t.integer :campaign_id

      t.timestamps
    end
  end
end
