require 'rails_helper'

RSpec.describe User, type: :model do
	before { @user = FactoryGirl.create(:user) }

	it { should respond_to :email }
	it { should respond_to :password }
	it { should respond_to :password_confirmation }
	it { should validate_presence_of(:email) }
	it { should validate_uniqueness_of(:email).case_insensitive }
	it { should validate_confirmation_of(:password) }
	it { should allow_value('example@domain.com').for(:email) }
	it { should respond_to :auth_token }
	it { should validate_uniqueness_of :auth_token }

	describe "#generate_authentication_token!" do
		it { expect(@user.auth_token).not_to be_nil }
		it 'generates a unique token for an User' do
			auth1 = @user.auth_token
			another_user = FactoryGirl.build(:user)
			expect(@user.auth_token).not_to eq another_user.auth_token
		end
	end
end
