class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.string :name
    end
  end
end
