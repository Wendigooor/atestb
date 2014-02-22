class RegistrationsController < Devise::RegistrationsController
  skip_before_filter :require_no_authentication, :only => [:create]

  def create
    super
    client = Client.find_by_email(params[:client][:email])
    
    unless client.profile
    	profile = Profile.new
    	profile.client = client
    	profile.save
    end
  end

  protected

  def sign_up(resource_name, resource)
    true
  end

end
