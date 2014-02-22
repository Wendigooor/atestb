class RestApiController < ActionController::Base
  protect_from_forgery

  def user_identify
    puts params
    Geocoder.configure(:lookup => :yandex, :timeout => 10)
    if params[:latitude].abs > 0.1 && params[:longitude].abs > 0.1
      search_loc = Geocoder.search([params[:latitude], params[:longitude]]).first
    else
      search_loc = nil
    end

    if params[:skip_register] && params[:skip_register] == true
      user = User.new(:latitude => params[:latitude], :longitude => params[:longitude], :macaddress => params[:macaddress], :build_version => params[:build_version])
    else
      user = User.new(:sex => params[:sex], :macaddress => params[:macaddress], :build_version => params[:build_version], :latitude => params[:latitude], :longitude => params[:longitude])

      age = params[:age]
      age_range = params[:age_range]

      if age_range.nil?
        if age == nil || age < 18
          user.age_range_id = 1
        elsif age >= 18 && age <= 25
          user.age_range_id = 2
        elsif age >= 26 && age <= 35
          user.age_range_id = 3
        elsif age >= 36 && age <= 50
          user.age_range_id = 4
        elsif age >= 51 && age <= 64
          user.age_range_id = 5
        elsif age >= 65
          user.age_range_id = 6
        end
      else
        user.age_range_id = age_range
      end
    end

    if search_loc
      if search_loc.country_code == "US"
        location = Location.find_by_state(search_loc.state)
      else
        location = Location.find_by_code(search_loc.country_code)
      end

      user.location = location if location
      user.country = location.country if location
    end

    if user.save
      render :json => {:result => "success"}
    else
      render :json => {:result => "error"}
    end
  end

  def ad_shown
    render :json => :ok
  end

  def fetch
    puts params

    sdkkey = Sdkkey.find_by_key(params[:sdk_key])
    if !sdkkey
      render :json => {:error => 'Sdkkey not found'}
      return
    end

    if !sdkkey.active?
      render :json => {:error => 'Sdkkey not active'}
      return
    end

    last_showed = params[:last_showed]
    if last_showed && last_showed.any?
      last_showed = Campaign.where('id in (?) and multiple = false', last_showed).map(&:id)
      last_showed << 0
    else
      last_showed = [0]
    end

    target_device = params[:target_device]
    if params[:target_device].nil?
      target_device = Campaign::DEVICES.map(&:last)
    else
      target_device = [target_device, 2]
    end

    show_time = params[:show_time]
    day = params[:day]

    user = User.find_by_macaddress(params[:macaddress])
    puts "USER #{user}"
    gender = []

    if user
      array = Click.where(:user_id => user.id).map(&:campaign_id).uniq
      array += params[:last_showed] ? params[:last_showed] : []
      last_showed = Campaign.where('id in (?) and multiple = false', array).map(&:id)

      gender = [user.sex, 2]

      if user.age_range_id.nil? || user.sex.nil?
        user_full_data = false
      else
        user_full_data = true
      end
    else
      last_showed = []

      gender = Campaign::GENDERS.map(&:last)

      user_full_data = false
    end
    last_showed << 0
    puts last_showed

    @campaigns = Campaign.where(:static_key => nil, :approved => true, :started => true, :target_device => target_device, :gender => gender).where('id not in (?) AND showed < purchased', last_showed)

    if !@campaigns.any?
      render :json => {:error => 'New campaigns not found'}
      return
    end

    puts @campaigns.inspect
    
    if user && user_full_data
      puts "Start filtering"
      user_found = 1
      @removable_campaigns = []

        # before answers
        @campaigns.each do |campaign|
          found = false
          if campaign.before_answers.any?
            campaign.before_answers.each do |answer|
              found = true if Click.where(:user_id => user.id, :answer_id => answer.id).any?
            end
          else
            found = true
          end

          @removable_campaigns << campaign if !found
        end  
        @removable_campaigns = @removable_campaigns.uniq
        @campaigns -= @removable_campaigns
        @removable_campaigns = []

        # age ranges
        @campaigns.each do |campaign|
          @removable_campaigns << campaign if !campaign.age_ranges.include?(user.age_range)
        end
        @removable_campaigns = @removable_campaigns.uniq
        @campaigns -= @removable_campaigns
        @removable_campaigns = []

        # locations
        @campaigns.each do |campaign|
          if user.location && campaign.locations.include?(user.location)
            @removable_campaigns << campaign
          end
        end
        @removable_campaigns = @removable_campaigns.uniq
        @campaigns -= @removable_campaigns
        @removable_campaigns = []

        # location point range
        @campaigns.each do |campaign|
          location_points = campaign.campaign_location_points
          if location_points.any?
            found = false
            location_points.each do |point|
              distance = Geocoder::Calculations.distance_between([user.latitude, user.longitude], [point.latitude, point.longitude])
              found = true if distance <= point.distance
            end
            @removable_campaigns << campaign if !found
          end
        end
        @removable_campaigns = @removable_campaigns.uniq
        @campaigns -= @removable_campaigns
        @removable_campaigns = []

        # time ranges
        if show_time && day
          @campaigns.each do |campaign|
            adv_periods = campaign.adv_periods.select { |period| period.day == day }
            if adv_periods.any?
              found = false
              adv_periods.each do |time_range|
                puts time_range.inspect
                puts show_time >= time_range.start && show_time <= time_range.end
                found = true if show_time >= time_range.start && show_time <= time_range.end
              end

              @removable_campaigns << campaign if !found
            end
          end
          @removable_campaigns = @removable_campaigns.uniq
          @campaigns -= @removable_campaigns
          @removable_campaigns = []
        end

        puts 'Campaigns after filters'
        puts @campaigns.inspect

    elsif !user_full_data && user
      user_found = 1
    else
      user_found = 0
    end

    sdkkey_placements = []
    sdkkey.sdkkey_placements.each do |sp|
      if sp.on
        sdkkey_placements << sp.placement.point
      end
    end

    if user_found == 0 || user_full_data
      if !@campaigns.any?
        render :json => {:error => 'New campaigns not found'}
        return
      end

      @campaign = @campaigns.shuffle.first
      if !@campaign
        render :json => {:error => 'No active campaign'}
      else
        result = @campaign.as_json(request.host_with_port)
        result["user_found"] = user_found
        result["sdkkey_placements"] = sdkkey_placements

        render :json => {
          :result => result,
          :user_full_data => (user_full_data ? 1 : 0)
        }
      end
    else
      if user.age_range_id.nil?
        puts "AGE RANGE NIL"
	static = Campaign.find_by_static_key('age').as_json(request.host_with_port)
      	puts "static #{static.inspect}"
      elsif user.sex.nil?
	puts "SEX NIL"
        static = Campaign.find_by_static_key('sex').as_json(request.host_with_port)
      else
        static = {}
      end
	 
	static["sdkkey_placements"] = sdkkey_placements if !static.nil?

      result = {}
      result = @campaign.as_json(request.host_with_port) if @campaign

      result["user_found"] = user_found

      puts @campaign.inspect

      json = {}
      json["result"] = result
      json["static"] = static
      #json["error"] = 'New campaigns not found' if @campaign.nil?
      json["user_full_data"] = (user_full_data ? 1 : 0)
      
      render :json => json
    end
  end

  def submit
    @campaign = Campaign.find(params[:id])
    user = User.find_by_macaddress(params[:macaddress])
    item = CampaignItem.find(params[:item_id])

    puts "#{user} #{@campaign}"
    if user && @campaign.static_key != nil
      puts 'qwe '
      if @campaign.static_key == "age"
        user.age_range_id = @campaign.campaign_items.index( item )
	user.age_range_id += 1
      elsif @campaign.static_key == "sex"
        user.sex = @campaign.campaign_items.index( item )
      end
      user.save
    else
      begin
        sdk_key = params[:sdk_key]

        if item.campaign_id != @campaign.id
          render :json => {:error => 'Item not found'}
          return
        end
      rescue Exception => e
        render :json => {:error => 'Campaign not found'}
        return
      end

      if not @campaign.approved or not @campaign.started or @campaign.showed >= @campaign.purchased
        render :json => {:error => 'Campaign not found'}
        return
      end

      unless Sdkkey.find_by_key(sdk_key)
        render :json => {:error => 'Application with current sdk key not found'}
        return
      else

        if params[:macaddress]
          if user
            click = Click.create(:date => Time.now(), :sdkkey => sdk_key, :campaign_id => @campaign.id, :answer_id => item.id, :user_id => user.id)
            if user.clicks_count
              user.clicks_count  += 1
            else
              user.clicks_count = 1
            end
            user.save
          end
        end
        @sdkkey = Sdkkey.find_by_key(sdk_key)
        @sdkkey.clicks += 1
        @sdkkey.save
      end
    end

    @campaign.showed += 1
    @campaign.save
    item.selected_count += 1
    item.save

    render :json => {:result => 'ok'}
  end

  def notification
    client_email = params[:option_name1]
    track_id = params[:ipn_track_id]
    payment = PaypalPayment.find_by_track_id(track_id)

    if payment
      puts "Payment found"
    else
      @client = Client.find_by_email(client_email)
      @client.balance += 1000
      @client.save

      payment = PaypalPayment.new(:track_id => track_id)
      payment.save
    end

    render status: 200
  end

  def upload_picture
    data = StringIO.new(Base64.decode64(params[:image_data_base64]))
    file_name = SecureRandom.hex + ".jpg"
    File.open("#{Rails.root}/public/images/#{file_name}",'wb') do |f|
      f.write data.read
    end

    render :json => {:status => :ok, :url => root_url + "images/#{file_name}"}
  end

  def delete_picture
    file_name = params[:file_name]
    file_path = "#{Rails.root}/public/images/#{file_name}"
    File.delete(file_path) if File.exist?(file_path)
    render :json => :ok
  end

end
