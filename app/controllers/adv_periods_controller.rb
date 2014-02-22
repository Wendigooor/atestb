class AdvPeriodsController < ApplicationController

	def create
		puts params
		day = params[:day]
		start_time = params[:start_time]
		end_time = params[:end_time]
		@campaign = Campaign.find(params[:campaign_id])

		period = AdvPeriod.create(:day => day, :start => start_time, :end => end_time)
		@campaign.adv_periods << period

		render :json => { 'html' => render_to_string(:partial => "adv_periods/campaign_periods", :locals => { :campaign => @campaign, :day => day }) }
	end

	def destroy
		period = AdvPeriod.find(params[:adv_period_id])
		day = period.day
		@campaign = period.campaign
		period.destroy

		render :json => { 'html' => render_to_string(:partial => "adv_periods/campaign_periods", :locals => { :campaign => @campaign, :day => day }) }
	end

	def adv_period_params
		
	end

end