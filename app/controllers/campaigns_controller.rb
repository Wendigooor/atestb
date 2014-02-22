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

			if @campaign.update_attributes(params[:campaign])
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
		@campaign.type_ad = params[:type_ad]

		(0..3).each do |i|
			@campaign.campaign_items.build
		end
	end

	def create
		@campaign = Campaign.new(params[:campaign])
		@campaign.type_ad = params[:type_ad]

		if current_client.admin
			if params[:client][:email] == ""
				redirect_to new_client_campaign_path(current_client, :type_ad => params[:type_ad], :step => true)
				flash[:notice] = "Choose Client for new campaign!"
				return
			else
				@client = Client.find_by_email(params[:client][:email])
				@campaign.client = @client
			end
		else
			@campaign.client = current_client
		end
		@campaign.started = true

		@campaign.age_ranges << AgeRange.all

		if @campaign.save
			redirect_to campaigns_audience_path(:campaign_id => @campaign.id)
		else
			redirect_to edit_client_campaign_path(current_client, @campaign)
		end
	end

	def audience
		@campaign = Campaign.includes(:locations, :age_ranges).find(params[:campaign_id])
	end

	def after_create
		@campaign = Campaign.find(params[:campaign_id])
		if @campaign.update_attributes(params[:campaign])
			puts 'ok'
		else
			puts 'not ok'
		end
	end

	def unapproved
		@campaigns = Campaign.where(:approved => false, :started => true)
	end

	def target
		@campaign = Campaign.find(params[:id])
	end

	def campaign_items
		@campaign = Campaign.find(params[:campaign_id])
		@campaign_items = @campaign.campaign_items.collect { |item| [item.id, "#{item.textUrl}"]  }
		render :json => @campaign_items.to_json
	end

	def before_answers
		@campaign = Campaign.find(params[:campaign_id])
		@before_answers = @campaign.before_answers.collect { |item| [item.id, "#{item.textUrl}"]  }
		puts "BEFORE ITEMS COUNT #{@before_answers.count}"
		render :json => @before_answers.to_json
	end

	def before_answers_table
		@campaign = Campaign.find(params[:campaign_id])
		@answers = CampaignItem.find_all_by_id(params[:answers_ids])
		@campaign.before_answers = @answers
		@answers.sort_by{|e| e[:campaign_id]}
		@campaigns = Campaign.find_all_by_id( @answers.map(&:campaign_id) )
		puts @answers.inspect
		puts @campaigns.inspect

		render :json => { 'html' => render_to_string(:partial => "campaigns/before_answers", :locals => { :answers => @answers }) }
	end

	def remove_campaign_before
		@campaign = Campaign.find(params[:campaign_id])
		@answers_to_remove = Campaign.find(params[:campaign_before_remove_id]).campaign_items
		@campaign.before_answers -= @answers_to_remove
		@answers = @campaign.before_answers

		render :json => { 'html' => render_to_string(:partial => "campaigns/before_answers", :locals => { :answers => @answers }) }
	end

	def excel
		@campaigns_hash = []
		@campaigns = Campaign.includes(:campaign_items).all
		@campaigns.each do |campaign|
			hash = { a: "Question", b: "#{campaign.id}", c: "#{campaign.caption}" }
			@campaigns_hash << hash

			campaign.campaign_items.each_with_index do |item, i|
				hash = { a: "", b: "#{item.id}", c: campaign.type_ad == 0 ? "#{item.textUrl}" : "image id(#{item.textUrl})"}
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
		@all_campaigns = params[:campaign_id] != "empty" ? Campaign.where('id LIKE ? OR caption LIKE ?', "%#{params[:campaign_id]}%", "%#{params[:campaign_id]}%") : Campaign.all
		render :json => { 'html' => render_to_string(:partial => "campaigns/campaigns", :locals => { :all_campaigns => @all_campaigns }) }
	end

end
