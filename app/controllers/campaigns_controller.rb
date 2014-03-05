class CampaignsController < ApplicationController

	def show
		@campaign = Campaign.find(params[:id])
	end

	def edit
		@campaign = Campaign.includes(:locations, :age_ranges).find(params[:id])

		count = 4 - @campaign.campaign_items.count

		(1..count).each do |i|
			@campaign.campaign_items.build
		end
	end

	def index
		@campaigns = current_client.campaigns
		@all_campaigns = Campaign.where(static_key: nil)

		@purchased_sum = @all_campaigns.inject(0){ |sum,c| sum += c.purchased }
		@showed_sum = @all_campaigns.inject(0){ |sum,c| sum += c.showed }
	end

	def update
		puts params
		@client = Client.find(params[:client_id])

		if current_client == @client or current_client.admin
			@campaign = Campaign.find(params[:id])

			if @campaign.update_attributes(campaign_params)
				if params[:step]
					redirect_to campaigns_audience_path(:campaign_id => @campaign.id)
				else
					redirect_to client_campaigns_path(current_client)
				end
			else
				flash[:notice] = @campaign.errors.full_messages
				redirect_to edit_client_campaign_path(current_client, @campaign)
			end
		else
			flash[:notice] = "You can't edit foreign campaigns"
			redirect_to client_campaigns_path(current_client)
		end
	end

	def destroy
		@client = Client.find(params[:client_id])

		if current_client == @client
			@campaign = Campaign.find(params[:id])

			if @campaign.destroy
				@client.balance += @campaign.purchased - @campaign.showed
				@client.save
				redirect_to client_campaigns_path(current_client)
			else
				flash[:notice] = @campaign.errors.full_messages
				redirect_to client_campaigns_path(current_client)
			end
		else
			flash[:notice] = "You can't destroy foreign campaigns"
			redirect_to client_campaigns_path(current_client)
		end
	end

	def new
		@campaign = Campaign.new
		(0..3).each do |i|
			@campaign.campaign_items.build
		end
	end

	def create
		@campaign = Campaign.new(campaign_params)

		@campaign.client = current_client
		@campaign.started = true
		@campaign.age_ranges << AgeRange.all

		if @campaign.save
			redirect_to client_campaigns_path(current_client)
		else
			redirect_to edit_client_campaign_path(current_client, @campaign)
		end
	end

	def audience
		@campaign = Campaign.includes(:locations, :age_ranges).find(params[:campaign_id])
	end

	def unapproved
		@campaigns = Campaign.where(:approved => false, :started => true)
	end

	def excel
		@campaigns_hash = []
		@campaigns = Campaign.includes(:campaign_items).all
		@campaigns.each do |campaign|
			hash = { a: "Question", b: "#{campaign.id}", c: "#{campaign.caption}" }
			@campaigns_hash << hash

			campaign.campaign_items.each_with_index do |item, i|
				hash = { a: "", b: "#{item.id}", c: item.content }
				@campaigns_hash << hash
			end
		end
		
		csv_data = CSV.generate do |csv|
			@campaigns_hash.each do |hash|
				csv << hash.values
			end
		end

		send_data(csv_data, :filename => "campaigns.csv")
	end

	def search
		@campaigns = params[:campaign_id] != "empty" ? Campaign.where('caption LIKE ?', "%#{params[:campaign_id]}%") : Campaign.all
		render :json => { 'html' => render_to_string(:partial => "campaigns/campaigns", :locals => { :campaigns => @campaigns }) }
	end

	private

	def campaign_params
  		params.require(:campaign).permit(:caption, :purchased, :showed, :approved,
  				:title_color, :border_color, :target_device, :font, :font_size, :campaign_age_ranges_attributes, :gender,
  				:multiple, :locations, :campaign_locations, :campaign_location_points_attributes,
  				age_range_ids: [],
  				location_ids: [],
  				:campaign_items_attributes => [:content])
	end

end
