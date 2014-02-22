class CreateCampaignAgeRanges < ActiveRecord::Migration
  def change
    create_table :campaign_age_ranges do |t|
      t.integer :campaign_id
      t.integer :age_range_id
      t.boolean :on, :default => true

      t.timestamps
    end

    drop_table :audiences

    add_column :campaigns, :campaign_before_id, :string
    add_column :campaigns, :gender, :integer, :default => 2

    remove_column :age_ranges, :audience_id

    add_column :age_ranges, :index, :integer

    change_column :campaigns, :multiple, :boolean, :default => false
  end
end
