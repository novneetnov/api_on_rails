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
		@user = User.find_by(auth_token: params[:auth_token])
		if @user == current_user
			@user.auth_token = nil
			@user.save!
			head 204
		else
			render json: { errors: "You are not authorized to perform this action" }, status: 422
		end
	end
end
