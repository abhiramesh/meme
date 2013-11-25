class PhotosController < ApplicationController

	before_filter :authenticate_user!
	

	def index
		@user = current_user
		@myfriendphotos = Rails.cache.fetch("photolist", :expires_in => 5.hours) do
			@myphotos = Photo.where(uid: @user.uid)
			@myfriendphotos = @user.photos.shuffle
		end
		
		respond_to do |format|
			if @myfriendphotos.count > 1
				format.js { render json: "yes" }
				format.html
			else
				format.js { render json: "no" }
				format.html
			end
		end
	end

	def new_meme
		@user = current_user
		@photo = Photo.find(params[:photo_id])
		respond_to do |format|
			format.html
		end
	end

end
