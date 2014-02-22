class ApprovesController < ActionController::Base

	def create #approve (admin) action
		@campaign = Campaign.find(params[:campaign_id])
		if current_client.admin
			@campaign.approved = @campaign.approved ? false : true
			@campaign.save
		end
		redirect_to params[:path]
	end

end