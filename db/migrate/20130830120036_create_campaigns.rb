class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|

      	t.integer :client_id
	    t.integer :type_ad, :default => 0
	    t.string :caption
	    t.integer :purchased, :default => 0
	    t.integer :showed, :default => 0
	    t.boolean :approved, :default => false
	    t.boolean :started, :default => false

    end
  end
end
