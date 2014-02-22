class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|

      t.integer :client_id
	    t.string :description
	    t.string :company
	    t.string :name
	    t.string :address
	  
      t.timestamps
    end
  end
end
