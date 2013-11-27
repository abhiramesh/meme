class FmemesController < ApplicationController

	before_filter :login_required, :except => [:show]

	require "s3"
	require "open-uri"
	require "base64"
	require 'will_paginate/array'

	def create
		service = S3::Service.new(:access_key_id => 'AKIAIMGYJXQ76NRH7YTQ', :secret_access_key => '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')
		meme_bucket = service.buckets.find("friendmeme")
		if params["memeURL"] && params["photo_id"]
			meme_object = Base64.decode64(params["memeURL"])
			new_meme = meme_bucket.objects.build('meme_' + current_user.id.to_s + '_' + params["photo_id"] + '.png' )
			new_meme.content = meme_object
			if new_meme.save
				fmeme = Fmeme.create(url: new_meme.url, user_id: current_user.id, photo_id: params["photo_id"].to_i, uid: Photo.find(params["photo_id"]).friend.uid)
				if fmeme.save
					render json: fmeme.id
				else
					render json: "error"
				end
			else
				render json: "error"
			end
		else
			render json: "error"
		end
	end

	def show
		if Fmeme.find(params[:id]).user == current_user
			@fmeme = Fmeme.find(params[:id])
			@friend = Friend.find_by_uid(@fmeme.uid)
			@post_permission = current_user.facebook.get_connections('me','permissions')[0]['publish_actions'].to_i == 1 ? true : false
		else
			redirect_to root_path
		end
	end

	def share_with_friend
		if params[:fmeme]
			begin
			@fmeme = Fmeme.find(params[:fmeme])
			@friend = Friend.find_by_uid(@fmeme.uid)
			@photo = current_user.facebook.put_picture(@fmeme.url.to_s, {:message => "I made a hilarious meme of #{@friend.name}! Make memes of your friends at http://www.mememyfriends.com" })
			@photo_id = @photo["id"]
			current_user.facebook.put_connections(@photo_id,'tags',{'to' => @friend.uid})
			redirect_to show_meme_path(@fmeme), :flash => { :notice => "Successfully posted to your wall." }
			rescue
				redirect_to show_meme_path(@fmeme)
			end
		else
			redirect_to '/fmemes'
		end
	end

	def index #user profile with saved memes
		@fmemes = current_user.fmemes.paginate(:page => params[:page], :per_page => 20)
	end

	def memes_of_me
		@fmemes = Fmeme.where(:uid => current_user.uid)
	end


end
