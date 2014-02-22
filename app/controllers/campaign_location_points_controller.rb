class CampaignLocationPointsController < ApplicationController

	def create
		point = CampaignLocationPoint.new(:address => params[:address], :latitude => params[:latitude], :longitude => params[:longitude], :distance => params[:distance])
		campaign = Campaign.find(params[:campaign_id])
		campaign.campaign_location_points << point

		render :json => { 'html' => render_to_string(:partial => 'campaign_location_points/points', :locals => { :campaign => campaign }) }
	end

	def destroy
		point = CampaignLocationPoint.find(params[:location_point_id])
		campaign = point.campaign
		point.destroy

		render :json => { 'html' => render_to_string(:partial => 'campaign_location_points/points', :locals => { :campaign => campaign }) }
	end

	def coordinates
		location = Geocoder.coordinates(params[:address])
		render :json => location.to_json
	end

end