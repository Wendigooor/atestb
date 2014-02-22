class ClientsController < ApplicationController
    before_filter :authenticate_client!
    skip_before_filter :authenticate_client!, :only => :add_money

	def show
		@client = params[:id] ? Client.find(params[:id]) : current_client
		@campaigns = Campaign.where(:approved => false, :started => true)
	end

	def edit
		@client = Client.find(params[:id])
	end

	def index
		@clients = Client.where(:developer => false, :admin => false)
	end

	def update
		@client = Client.find(params[:id])
		if @client == current_client
			if @client.update_attributes(params[:client])
				redirect_to client_path(current_client)
			else
				flash[:notice] = @campaign.errors.full_messages
				puts @campaign.errors.full_messages
				redirect_to edit_client_path(current_client)
			end
		else
			client_path(current_client)
		end
	end

	def add_money
		client = Client.find(params[:client_id])
		client.balance += 1000
		if client.save
			render :json => { :status => :ok, :balance => client.balance }
		else
			render :json => { :status => :balance_problem, :balance => client.balance }
		end
	end

	def destroy
		new_client_session_path
	end

	def new
		puts params
		@client = Client.new
	end

	def create
		if current_client.admin
			@client = Client.create!(:username => params[:username], :email => params[:email], :password => params[:password], :password_confirmation => params[:password])
		end

		redirect_to client_path(current_client)
	end

end
