require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
	before :each do
		request.headers['Accept'] = "application/vnd.marketplace.v1"
	end

	describe "User#show: " do
		before :each do
			@user = FactoryGirl.create :user
			get :show, params: { id: @user.id }, format: :json
		end

		it 'returns the information about a reporter on a hash' do
			user_response = JSON.parse(response.body, symbolize_names: true)
			expect(user_response[:email]).to eql @user.email
		end

		it { should respond_with 200 }

	end

	describe "User#create: " do
		context "when User is successfully created" do
			before :each do
				@user_attributes = FactoryGirl.attributes_for :user
				post :create, params: { user: @user_attributes }, format: :json
			end

			it 'should render the User created in Json format' do
				user_response = JSON.parse response.body
				expect(user_response["email"]).to eql @user_attributes[:email]
			end
			it { should respond_with 201 }
		end

		context "when User is not created" do
			before :each do
				@invalid_user_attributes = { password: "12345678", password_confirmation: "12345678" }
				post :create, params: { user: @invalid_user_attributes }, format: :json
			end

			it { should respond_with 422 }
			it 'should render json errors on why User could not be created' do
				user_response = JSON.parse response.body
				expect(user_response).to have_key "errors"
				expect(user_response["errors"]["email"].first).to eq "can't be blank"
			end
		end
	end

	describe "User#update: " do
		before { @user = FactoryGirl.create :user }	
		context "when User is successfully updated" do
			before :each do
				@new_email = "new@email.com"
				patch :update, params: { id: @user.id, user: { email: @new_email } }, format: :json
			end

			it { should respond_with 200 }
			it 'should render the User updated in Json format ' do
				user_response = JSON.parse response.body
				expect(user_response["email"]).to eq @new_email
			end
		end

		context "when User is not successfully updated" do
			before :each do
				@new_email = ""
				patch :update, params: { id: @user.id, user: { email: @new_email } }, format: :json
			end

			it { should respond_with 422 }
			it 'should render json errors on why User could not be updated' do
				user_response = JSON.parse response.body
				expect(user_response).to have_key "errors"
				expect(user_response["errors"]["email"].first).to eq "can't be blank"
			end
		end
	end
end
