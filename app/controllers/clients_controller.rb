class ClientsController < ApplicationController
	before_filter :authenticate_client!
	before_filter :find_client, only: [:show, :edit, :update, :destroy]

	def show
		respond_to do |format|
			format.html
			format.json { render json: @client }
		end
	end

	def edit
	end

	def index
		@clients = Client.where(:developer => false, :admin => false)
	end

	def update
		if @client.update_attributes(client_params)
			redirect_to client_path(current_client)
		else
			flash[:notice] = @campaign.errors.full_messages
			redirect_to edit_client_path(current_client)
		end
	end

	def destroy
		@client.destroy

		respond_to do |format|
			format.html { redirect_to new_client_session_path }
			format.json { render json: json_wrapper(@client) }
		end
	end

	def new
		@client = Client.new

		respond_to do |format|
			format.html
			format.json { render json: @client }
		end
	end

	def create
		@client = Client.create(client_params)

		respond_to do |format|
			if @client.save
				format.html { redirect_to client_path(current_client), notice: "Client #{@client.name} was successfully created." }
				format.json { render json: @client, status: :created, location: current_client }
			else
				format.html { render action: "new" }
				format.json { render json: @client.errors, status: :unprocessable_entity }
			end
		end
	end

	private

	def client_params
		params.require(:client).permit(:email, :password, :password_confirmation, :username, :developer)
	end

	def find_client
		@client = Client.find(params[:id])
	end

end
