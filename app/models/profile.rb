class Profile < ActiveRecord::Base
 	attr_accessible :description, :company, :name, :address

 	belongs_to :client
end
