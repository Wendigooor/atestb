class SdkkeysController < UsersController

	require 'securerandom'

	def index
		if current_client.admin
			@keys = Sdkkey.all
		else
			@keys = current_client.sdkkeys
			@key = Sdkkey.new
		end
	end

	def destroy
		@key = Sdkkey.find(params[:id])
		@key.destroy

		redirect_to params[:path]
	end

	def new
		@key = Sdkkey.new
	end

	def create
		@key = Sdkkey.new(params[:sdkkey])
		@client = Client.find(params[:client_id])

		random_key = SecureRandom.hex
		while Sdkkey.find_by_key(random_key)
			random_key = SecureRandom.hex
		end
		@key.key = random_key
		@key.client = @client

		@key.placements << Placement.all

		if @key.save
			redirect_to params[:path]
		else
			flash[:error] = @key.errors.full_messages
			redirect_to params[:path]
		end
	end

	def activate
		puts params

		@key = Sdkkey.find(params[:key_id])
		@key.active = !@key.active
		@key.save

		redirect_to params[:path]
	end

	def update_placements
		puts params
		sp = SdkkeyPlacement.where(:sdkkey_id => params[:sdkkey_id], :placement_id => params[:placement_id]).first
		sp.on = params[:checked]
		puts sp.inspect
		sp.save
		puts sp.inspect
		render :json => :ok
	end

	def users
		@sdkkey = Sdkkey.find(params[:id])
		@users = User.where(:id => Click.where(:sdkkey => @sdkkey.key).map(&:user_id)).order(sort_column + " " + sort_direction)
		@users = @users.paginate(:page => params[:page], :per_page => 50)
	end

end