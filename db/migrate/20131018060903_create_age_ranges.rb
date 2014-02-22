class CreateAgeRanges < ActiveRecord::Migration
  def change
    create_table :age_ranges do |t|
      t.integer :age_left
      t.integer :age_right
      t.integer :audience_id

      t.timestamps
    end
  end
end
