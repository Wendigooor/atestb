class ActivatesController < ApplicationController

	def create
		@campaign = Campaign.find(params[:campaign_id])
		if current_client.admin || @campaign.client == current_client
			@campaign.started = !@campaign.started
			@campaign.save
		end
		redirect_to client_campaigns_path(current_client)
	end

end