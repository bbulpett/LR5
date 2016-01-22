Rails.application.routes.draw do
  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'

  resources :sessions

  resources :users
  resources :courses do
  	member do
  		get :roll
  	end
  end

  resources :students do
		resources :awards

		member do
			get :courses
			post :course_add
			post :course_remove
		end
	end
  


  root to: "students#index"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
