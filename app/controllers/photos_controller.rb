class PhotosController < ApplicationController

	before_filter :login_required
	
	require 'will_paginate/array'


	def index
		@user = current_user
		if Delayed::Job.where(queue: "friends_" + @user.id.to_s)
			@myfriendphotos = Rails.cache.fetch("photolist", :expires_in => 30.seconds) do
				# @myphotos = Photo.where(uid: @user.uid)
				@myfriendphotos = @user.photos
			end
		else
			@myfriendphotos = Rails.cache.fetch("photolistreal") do
				# @myphotos = Photo.where(uid: @user.uid)
				@myfriendphotos = @user.photos
			end
		end
		@myfriendphotos = @myfriendphotos.shuffle.paginate(:page => params[:page], :per_page => 30)
		
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
	end

	def search_results
		if params["query"] && current_user.friends.find_by_name(params["query"])
			@friend = current_user.friends.find_by_name(params["query"])
			@friendphotos = @friend.photos
		else
			redirect_to root_path
		end
	end

	respond_to do |format|
		format.html
	end
	

end
