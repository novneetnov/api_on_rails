Rails.application.routes.draw do
  devise_for :users
	namespace :api, constraints: { subdomain: 'api' }, path: '/' do
		scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
			resources :products 
		end
	end
end
