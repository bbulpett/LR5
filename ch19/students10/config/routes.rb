Rails.application.routes.draw do
  
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
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
