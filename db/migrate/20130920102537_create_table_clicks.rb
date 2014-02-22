class CreateTableClicks < ActiveRecord::Migration
  	def up
	  create_table :clicks do |t|      
	    t.date :date
	    t.string :sdkkey
	    t.integer :campaign_id
	    t.integer :answer_id
	    t.timestamps      
	  end
	end

	def down
	    drop_table :clicks
	end
end
