class DevelopersController < ApplicationController

	def index
		@developers = Client.where(:developer => true)
	end

	def show
		@developer = Client.find(params[:id])
		@key = Sdkkey.new
	end

end