class ApplicationController < ActionController::Base 
  protect_from_forgery

  require 'will_paginate/array'

  def after_sign_in_path_for(resource)
	if current_client
 		client_path(current_client)
 	else
	    new_client_session_path
	end
  end

  def after_sign_out_path_for(resource)
	new_client_session_path
  end

end
