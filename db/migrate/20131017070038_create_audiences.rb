class CreateAudiences < ActiveRecord::Migration
  def change
    create_table :audiences do |t|
      t.integer :campaign_id
      t.integer :gender

      t.timestamps
    end
  end
end
