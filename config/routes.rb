Rails.application.routes.draw do
	namespace :api, constraints: { subdomain: 'api' }, path: '/' do
		resources :posts 
	end
end
