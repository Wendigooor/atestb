class CreateAdvPeriods < ActiveRecord::Migration
  def change
    create_table :adv_periods do |t|
      t.string :day
      t.integer :start
      t.integer :end
      t.integer :campaign_id

      t.timestamps
    end

  end
end
