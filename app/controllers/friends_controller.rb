class FriendsController < ApplicationController

	before_filter :login_required

	def get_friends
		if params["term"]
			@friends = current_user.friends.find(:all,:conditions => ["name iLIKE ?","%#{params["term"].downcase}%"])
		else
			@friends = current_user.friends
		end

		respond_to do |format|
			format.json { render :json => @friends.to_json }
		end
	end

end
