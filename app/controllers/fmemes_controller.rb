class FmemesController < ApplicationController

	before_filter :authenticate_user!

	require "s3"
	require "open-uri"
	require "base64"


	def create
		service = S3::Service.new(:access_key_id => 'AKIAIMGYJXQ76NRH7YTQ', :secret_access_key => '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')
		meme_bucket = service.buckets.find("friendmeme")
		if params["memeURL"] && params["photo_id"]
			meme_object = Base64.decode64(params["memeURL"])
			new_meme = meme_bucket.objects.build('meme_' + current_user.id.to_s + '_' + params["photo_id"] + '.png' )
			new_meme.content = meme_object
			if new_meme.save
				fmeme = Fmeme.create(url: new_meme.url, user_id: current_user.id, photo_id: params["photo_id"].to_i)
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
		@fmeme = Fmeme.find(params[:id])
	end

	def index #user profile with saved memes
		@fmemes = current_user.fmemes
	end


end
