class UsersController < ApplicationController
helper_method :sort_column, :sort_direction

	def index
		@date_from = User.first.created_at.strftime("%Y-%m-%d")
		@date_to = Date.today

		@answer_date_from = User.first.created_at.strftime("%Y-%m-%d")
		@answer_date_to = Date.today

		if params[:search]
			@date_from = params[:search][:datepicker_from] != "" ? params[:search][:datepicker_from].to_time.strftime("%Y-%m-%d") : Date.today
			@date_to   = params[:search][:datepicker_to]   != "" ? params[:search][:datepicker_to].to_time.strftime("%Y-%m-%d")   : Date.today
			@answer_date_from = params[:search][:answer_datepicker_from] != "" ? params[:search][:answer_datepicker_from].to_time.strftime("%Y-%m-%d") : Date.today
			@answer_date_to   = params[:search][:answer_datepicker_to]   != "" ? params[:search][:answer_datepicker_to].to_time.strftime("%Y-%m-%d")   : Date.today
		end

		@age_ranges = AgeRange.all
		puts @age_ranges.inspect

		if !params[:search]
			@users = User.includes(:location).order(sort_column + " " + sort_direction).paginate(:page => params[:page], :per_page => 50)
			return
		end

		sex = params[:search][:sex].to_i
		if sex == 2
			sex = (0..1)
		end

		@age_ranges = AgeRange.find_all_by_id(params[:search][:age_range_ids])

		date_range = (@date_from.to_time.beginning_of_day..@date_to.to_time.end_of_day)
		answer_date_range = (@answer_date_from.to_time.beginning_of_day..@answer_date_to.to_time.end_of_day)

		@users = User.includes(:clicks).where(:age_range_id => @age_ranges.map(&:id), :sex => sex, :created_at => date_range, :created_at => date_range, :clicks => { created_at: answer_date_range }).order(params[:sort] + " " + params[:direction]).paginate(:page => params[:page], :per_page => 50)

		puts 'user search parameters'
		puts sex
		puts date_range
	end

	def show
		@user = User.find(params[:id])
		@clicks = Click.find_all_by_user_id(@user.id)
	end

	def excel

		@date_from = User.first.created_at.strftime("%Y-%m-%d")
		@date_to = Date.today

		@answer_date_from = User.first.created_at.strftime("%Y-%m-%d")
		@answer_date_to = Date.today

		if params[:search]
			@date_from = params[:search][:datepicker_from] != "" ? params[:search][:datepicker_from].to_time.strftime("%Y-%m-%d") : Date.today
			@date_to   = params[:search][:datepicker_to]   != "" ? params[:search][:datepicker_to].to_time.strftime("%Y-%m-%d")   : Date.today
			@answer_date_from = params[:search][:answer_datepicker_from] != "" ? params[:search][:answer_datepicker_from].to_time.strftime("%Y-%m-%d") : Date.today
			@answer_date_to   = params[:search][:answer_datepicker_to]   != "" ? params[:search][:answer_datepicker_to].to_time.strftime("%Y-%m-%d")   : Date.today
		end

		if !params[:search]
			@age_ranges = AgeRange.all
			@users = User.includes(:clicks)
		else
			sex = params[:search][:sex].to_i
			if sex == 2
				sex = (0..1)
			end
			
			@age_ranges = AgeRange.find_all_by_id(params[:search][:age_range_ids])

			date_range = (@date_from.to_time.beginning_of_day..@date_to.to_time.end_of_day)
			answer_date_range = (@answer_date_from.to_time.beginning_of_day..@answer_date_to.to_time.end_of_day)

			if params[:sort]
				@users = User.includes(:clicks).where(:age_range_id => @age_ranges.map(&:id), :sex => sex, :created_at => date_range, :clicks => { created_at: answer_date_range }).order(params[:sort] + " " + params[:direction])		
			else
				@users = User.includes(:clicks).where(:age_range_id => @age_ranges.map(&:id), :sex => sex, :created_at => date_range, :clicks => { created_at: answer_date_range })
			end
		end

		campaigns = Campaign.all

		csv_data = CSV.generate do |csv|

			titles = ['Macaddress', 'Age', 'Sex', 'Latitude', 'Longitude', 'Location']
			campaigns.each do |c|
				titles << c.id
				titles << "Date"
			end

			csv << titles
			@users.each do |user|
				user_line = []
				user_line << user.macaddress
				user_line << user.age_range.full_range
				user_line << user.sex
				user_line << user.latitude
				user_line << user.longitude
				user_line << user.country #location(user)

				campaigns.each do |c|
					clicks = user.clicks.select {|click| click.campaign_id == c.id }

					answer_id   = clicks.last.try(:answer_id) || ''
					answer_date = clicks.any? ? clicks.last.created_at.strftime("%H:%M %Y-%m-%d") : ''

					user_line << answer_id
					user_line << answer_date
				end
				csv << user_line
			end
		end

		send_data(csv_data, :filename => "users.csv")
	end

	def user_answer(user_id, campaign_id)
		user = User.find(user_id)
		item = 'Item # ' + (Campaign.find(campaign_id).campaign_items.index( CampaignItem.find(Click.where(user_id: user.id, campaign_id: campaign_id).first.answer_id) ) + 1).to_s
	end

	def count
		#puts params
	
		# age_ranges			 = AgeRange.find_all_by_id(params[:age])
		# gender 				 = Campaign::GENDERS.map(&:last) if params[:gender].include?("2")
		# target_device 		 = Campaign::DEVICES.map(&:last) if params[:target_device].include?("2")
		# campaign 			 = Campaign.find(params[:campaign_id])

		# users = []

		# age_ranges.each do |age_range|
		# 	User.all.each do |user|
		# 		users << user if !user.age || user.age < 18 || (user.age >= age_range.age_left && user.age <= age_range.age_right)
		# 	end
		# end
		
		# users = User.where(:sex => (gender.first..gender.last))

		# render :json => {:status => :ok, :count => users.count}
	end

	private

	def sort_column
		puts params[:sort]
		User.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
	end

	def sort_direction
		%w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
	end
end

