class AddPointToPlacements < ActiveRecord::Migration
  def change
    add_column :placements, :point, :integer
  end
end
