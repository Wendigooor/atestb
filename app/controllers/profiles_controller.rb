class ProfilesController < ApplicationController

	def show
		puts params
		
		@profile = Profile.find(params[:id])
		@client = Client.find(params[:client_id])
	end

	def update
  		@profile = Profile.find(params[:id])
		@client = Client.find(params[:client_id])
  		puts params
  		puts @profile.inspect
 
  		if @profile.update_attributes(params[:profile])
    		redirect_to client_profile_path(@client, @profile)
  		else
  			render 'show'
  		end
	end

end