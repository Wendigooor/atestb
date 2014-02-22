class StatisticsController < ApplicationController

	def index
		@client = Client.find(params[:client_id])
		@campaign = Campaign.find(params[:campaign_id])
		@first_click = Click.where(:campaign_id => @campaign.id).first
		
		if @first_click
			first_date = @first_click.created_at.to_date - 1
		else
			first_date = Date.today - 1
		end

		@dates = first_date..Date.today
		puts @dates.inspect

		@clicks_counts = []

		@dates.each do |date|
			puts date.to_s
			count = Click.where(:created_at => (date.beginning_of_day..date.end_of_day), :campaign_id => @campaign.id).count
			@clicks_counts << count
		end

		@today 	   = Date.today
		@yesterday = Date.yesterday
		@this_week = (@today.at_beginning_of_week)..@today
		@last_week = ((@today.at_beginning_of_week - 1).at_beginning_of_week..@today.at_beginning_of_week)

		@today_clicks     = Click.where(:created_at => (@today.beginning_of_day..@today.end_of_day), :campaign_id => @campaign.id)
		@yesterday_clicks = Click.where(:created_at => (@yesterday.beginning_of_day..@yesterday.end_of_day), :campaign_id => @campaign.id)
		@this_week_clicks = Click.where(:created_at => (@this_week.first.beginning_of_day..@this_week.last.end_of_day), :campaign_id => @campaign.id)
		@last_week_clicks = Click.where(:created_at => (@last_week.first.beginning_of_day..@last_week.last.end_of_day), :campaign_id => @campaign.id)

		@today_impressions	   = Impression.where(:created_at => (@today.beginning_of_day..@today.end_of_day), :campaign_id => @campaign.id)
		@yesterday_impressions = Impression.where(:created_at => (@yesterday.beginning_of_day..@yesterday.end_of_day), :campaign_id => @campaign.id)
		@this_week_impressions = Impression.where(:created_at => (@this_week.first.beginning_of_day..@this_week.last.end_of_day), :campaign_id => @campaign.id)
		@last_week_impressions = Impression.where(:created_at => (@last_week.first.beginning_of_day..@last_week.last.end_of_day), :campaign_id => @campaign.id)

		@range_dates_clicks = []
		@range_dates_impressions = []
		@date_from = Date.today
		@date_to = Date.today
		if params[:range_dates]
			@date_from = params[:range_dates][:datepicker_from] != "" ? params[:range_dates][:datepicker_from].to_time : Date.today
			@date_to   = params[:range_dates][:datepicker_to]   != "" ? params[:range_dates][:datepicker_to].to_time   : Date.today
			@range_dates_clicks 	= Click.where(:created_at => (@date_from.beginning_of_day..@date_to.end_of_day), :campaign_id => @campaign.id)
			@range_dates_impressions = Impression.where(:created_at => (@date_from.beginning_of_day..@date_to.end_of_day), :campaign_id => @campaign.id)
		end
	end

	def answered_users
		puts params
		@clicks = Click.where(campaign_id: params[:campaign_id])
		@user_ids = @clicks.map { |c| c.user_id }
		@users = User.find(:all, :conditions => ["id in (?)", @user_ids]).uniq

		if params[:search]
			
			age_left = params[:search][:age_left].to_i
			age_right = params[:search][:age_right].to_i
			sex = params[:search][:sex].to_i

			if age_right == 0
				age_right = 200
			end
		
			if age_left > age_right
				age_left = age_right - 1
			end

			unless params[:search][:age_left].blank? and params[:search][:age_right].blank? and sex == 2
				if sex == 2
					@users = @users.select { |u| u.age >= age_left && u.age <= age_right }
				else
					@users = @users.select { |u| u.age >= age_left && u.age <= age_right && u.sex == sex }
				end
			end
		end
	end

	def global_statistic
		@first_click = Click.first
		if @first_click
			first_date = @first_click.created_at.to_date - 1
		else
			first_date = Date.today - 1
		end
		@dates = first_date..Date.today

		@clicks_counts = []

		@dates.each do |date|
			puts date.to_s
			count = Click.where(:created_at => (date.beginning_of_day..date.end_of_day)).count
			@clicks_counts << count
		end

		@today 	   = Date.today
		@yesterday = Date.yesterday
		@this_week = (@today.at_beginning_of_week)..@today
		@last_week = ((@today.at_beginning_of_week - 1).at_beginning_of_week..@today.at_beginning_of_week)

		@today_clicks 	  = Click.where(:created_at => (@today.beginning_of_day..@today.end_of_day))
		@yesterday_clicks = Click.where(:created_at => (@yesterday.beginning_of_day..@yesterday.end_of_day))
		@this_week_clicks = Click.where(:created_at => (@this_week.first.beginning_of_day..@this_week.last.end_of_day))
		@last_week_clicks = Click.where(:created_at => (@last_week.first.beginning_of_day..@last_week.last.end_of_day))

		@today_impressions	   = Impression.where(:created_at => (@today.beginning_of_day..@today.end_of_day))
		@yesterday_impressions = Impression.where(:created_at => (@yesterday.beginning_of_day..@yesterday.end_of_day))
		@this_week_impressions = Impression.where(:created_at => (@this_week.first.beginning_of_day..@this_week.last.end_of_day))
		@last_week_impressions = Impression.where(:created_at => (@last_week.first.beginning_of_day..@last_week.last.end_of_day))

		@range_dates_clicks = []
		@range_dates_impressions = []
		@date_from = Date.today
		@date_to = Date.today
		if params[:range_dates]
			@date_from = params[:range_dates][:datepicker_from] != "" ? params[:range_dates][:datepicker_from].to_time : Date.today
			@date_to   = params[:range_dates][:datepicker_to]   != "" ? params[:range_dates][:datepicker_to].to_time   : Date.today
			@range_dates_clicks = Click.where(:created_at => (@date_from.beginning_of_day..@date_to.end_of_day))
			@range_dates_impressions = Impression.where(:created_at => (@date_from.beginning_of_day..@date_to.end_of_day))
		end

	end

	def excel
		@clicks = Click.where(campaign_id: params[:campaign_id])
		@user_ids = @clicks.map { |c| c.user_id }
		@users = User.find(:all, :conditions => ["id in (?)", @user_ids]).uniq

		@answered_users = @users.collect{|user| {:age => user.age, :sex => user.sex, :latitude => user.latitude, :longitude => user.longitude, :location => user_location(user.id), :answer => user_answer(user.id, params[:campaign_id])}}

		csv_data = CSV.generate do |csv|
			csv << @answered_users.first.keys
  			@answered_users.each do |hash|
    			csv << hash.values
	  		end
		end

		send_data(csv_data, :filename => "user.csv")
	end

	def user_location(user_id)
		user = User.find(user_id)
		if user.location
			loc = user.location.country.to_s + " | " + user.location.state.to_s
		else
			loc = ''
		end
	end

	def user_answer(user_id, campaign_id)
		user = User.find(user_id)
		item = 'Item # ' + (Campaign.find(campaign_id).campaign_items.index( CampaignItem.find(Click.where(user_id: user.id, campaign_id: campaign_id).first.answer_id) ) + 1).to_s
	end

	def user_campaign_clicks
		@campaign = Campaign.new()
	end
end
