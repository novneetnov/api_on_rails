require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
	before :each do
		@user = FactoryGirl.create(:user)
	end
	
	describe "Sessions#create" do
		context "When the credentials are correct" do
			before :each do
				credentials = FactoryGirl.attributes_for :user
				post :create, params: { id: @user.id, session: credentials }
			end

			it { should respond_with 201 }
			it 'returns a user record corresponding to the given credentials' do
				@user.reload
				expect(json_response[:auth_token]).to eq @user.auth_token
			end
		end

		context "When the credentials are incorrect" do
			before :each do
				credentials = { email: @user.email, password: "invalid" }
				post :create, params: { id: @user.id, session: credentials }
			end

			it { should respond_with 422 }
			it 'returns a json with an error' do
				expect(json_response[:errors]).to eq "Invalid Username or Password"
			end
		end
	end

	describe "Sessions#destroy" do
		before do 
			sign_in @user
		end
		context "Signed in User destroys his session" do
			before { delete :destroy, params: { id: @user.id, auth_token: @user.auth_token } }
			it 'the User should have a nil or empty auth_token' do
				@user.reload
				expect(@user.auth_token).to be_nil
			end
			it { should respond_with 204 }
		end

		context "Signed in User tries to destroy another user's session" do
			before do
				@another_user = FactoryGirl.create :user
				delete :destroy, params: { id: @another_user.id, auth_token: @another_user.auth_token }
			end

			it 'should respond with an error message' do
				expect(json_response[:errors]).to eq "You are not authorized to perform this action"
			end
			it { should respond_with 422 }
		end
	end
end
