class CreateSdkKeys < ActiveRecord::Migration
  def change
    create_table :sdkkeys do |t|
      t.string :key

      t.timestamps
    end
  end
end
