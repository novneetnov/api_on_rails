class Api::V1::SessionsController < ApplicationController
	def create
		email = params[:session][:email]
		password = params[:session][:password]
		user = User.find(params[:id])
		if not user.nil? and user.valid_password? password
			sign_in user
			user.generate_authentication_token!
			user.save
			render json: user, status: 201 
		else
			render json: { errors: "Invalid Username or Password" }, status: 422
		end
	end

	def destroy
		@user = User.find(params[:id])
		@user.auth_token = nil
		@user.save!
	end
end
