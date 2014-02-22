class RegistrationsController < Devise::RegistrationsController

  def create
    super
    client = Client.find_by_email(params[:client][:email])
   	profile = Profile.new
   	profile.client = client
   	profile.save
  end

end
