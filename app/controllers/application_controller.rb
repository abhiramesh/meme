class ApplicationController < ActionController::Base
  protect_from_forgery

  def after_sign_in_path_for(resource)
  	'/all_photos'
  end

  def after_sign_out_path_for(resource)
  	root_path
  end

  def login_required
  	if current_user.blank?
  		redirect_to root_path
  	end
  end


end
