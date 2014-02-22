class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|

      t.string 		:macaddress
      t.integer		:age
      t.boolean		:sex
      t.float		:latitude
      t.float		:longitude

      t.timestamps
    end
  end
end
