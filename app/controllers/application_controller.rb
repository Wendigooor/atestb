class ApplicationController < ActionController::Base 
  protect_from_forgery
  before_filter :update_sanitized_params, if: :devise_controller?

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

  def update_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:email, :password, :password_confirmation, :username, :developer)}
  end

end
