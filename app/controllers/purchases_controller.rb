class PurchasesController < ActionController::Base

	def minimal_purchase
		Settings.minimal_purchase = params[:minimal_purchase].to_f
		render :json => { :status => :ok }
	end

	def create
		purchase = params[:purchase].to_f.abs
		@campaign = Campaign.find(params[:campaign_id])

		if purchase < Settings.minimal_purchase
			render :json => { :status => :not_ok, :balance => current_client.balance, :campaign_purchased => @campaign.purchased, :reason => "Minimum purchase amount is " + Settings.minimal_purchase.to_s + " credits" }
		elsif @campaign.client == current_client
			if current_client.balance - purchase >= 0
				@campaign.purchased += purchase
				current_client.balance -= purchase
				@campaign.save
				current_client.save
				render :json => { :status => :ok, :balance => current_client.balance, :campaign_purchased => @campaign.purchased, :reason => "Purchase was successful!" }
			else
				render :json => { :status => :not_ok, :balance => current_client.balance, :campaign_purchased => @campaign.purchased, :reason => "Not enough credits." }
			end
		else
			render :json => { :status => :not_ok, :balance => "<Undefined>", :reason => "Sorry, we have temporary problems. Please, try again later." }
		end
	end

	def add_credits
		@client = Client.find(params[:client_id])
		@client.balance += params[:credits].to_f
		@client.save
		render :json => { :status => :ok, :balance => @client.balance }
	end

end