class ProfilesController < ApplicationController

	def show
		@client = Client.find(params[:client_id])
		@profile = @client.profile

		respond_to do |format|
			format.html
			format.json { render json: @profile }
		end
	end

	def edit
		@client = Client.find(params[:client_id])
		@profile = @client.profile

		respond_to do |format|
			format.html
			format.json { render json: @profile }
		end
	end

	def update
		@client = Client.find(params[:client_id])
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
end
