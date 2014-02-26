class ProfilesController < ApplicationController
	before_filter :find_client
	
	def show
		@profile = @client.profile

		respond_to do |format|
			format.html
			format.json { render json: @profile }
		end
	end

	def edit
		@profile = @client.profile
	end

	def update
		@profile = @client.profile

		if @profile.update_attributes(profile_params)
			redirect_to client_profile_path(@client, @profile)
		else
			flash[:notice] = @profile.errors.full_messages
			redirect_to edit_client_profile_path(@client, @profile)
		end
	end

	private

	def profile_params
		params.require(:profile).permit(:description, :company, :name, :address)
	end

	def find_client
		@client = Client.find(params[:client_id])
	end

end
