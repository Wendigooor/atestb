class LocationsController < ActionController::Base

	def create
		@campaign = Campaign.find(params[:campaign_id])
		if params[:filter] == "true"
			Location.destroy_all(:campaign_id => @campaign.id)
			@countries = !params[:target].blank? ? params[:target][:country] : []
			@states = !params[:target].blank? ? params[:target][:state] : []

			if @countries.any?
				if @countries.include?("")
					puts "All countries"
				else
					@countries.each do |country|
						country_name = Carmen::Country.coded(country).name
						if country == "US" and @states.any?
							@states.each do |state|
								state_name = Carmen::Country.coded(country).subregions.coded(state).name
								location = Location.new(:country => country_name, :state => state_name)
								location.save
								location.campaign_id = @campaign.id
								@campaign.locations << location
							end
						else
							location = Location.new(:country => country_name, :state => "")
							location.save
							location.campaign_id = @campaign.id
							@campaign.locations << location
						end			
					end
				end
			end
		end

		redirect_to client_campaign_path(current_client, @campaign)
	end

end
