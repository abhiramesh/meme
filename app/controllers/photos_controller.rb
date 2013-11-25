class PhotosController < ApplicationController

	before_filter :authenticate_user!
	
	def create_meme
		@user = current_user
		@myphotos = Photo.where(uid: @user.uid)
		@myfriendphotos = @user.photos
		respond_to do |format|
			if @myfriendphotos.count > 1
				format.js { render json: "yes" }
			else
				format.js { render json: "no" }
			end
		end
	end

end
