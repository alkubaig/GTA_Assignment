Rails.application.routes.draw do

  get 'help/index'

  namespace :administrator do
  get 'sections/_section'
  end

  namespace :administrator do
  get 'sections/index'
  end

  namespace :administrator do
  get 'sections/show'
  end

  namespace :administrator do
  get 'students/index'
  end

  namespace :administrator do
  get 'students/_student'
  end

  namespace :administrator do
  get 'students/show'
  end

  namespace :administrator do
  get 'students/edit'
  end
  
  namespace :administrator do
  get 'admin_section_preferences/_admin_section_preferences'
  end

  namespace :administrator do
  get 'admin_section_preferences/index'
  end

  namespace :administrator do
  get 'admin_section_preferences/show'
  end

  get 'white_courses/index'

  get 'courses/Sync'

  get 'courses/index'

  root 'pages#index'

  devise_for :users, :controllers => {
    :omniauth_callbacks => "users/omniauth_callbacks"
  }

  resources :skills
  
  resources :student do 
  	
  	  # Students
  	resources :section_preferences do 
    	collection do
    		post :collect_pref
    		
    	end
    end
  resources :experiences do
    	collection do
    		post :collect_experiences
    	end
    end
  	
  	
  end



  # Instructors
  resources :sections do
  	post :comment
    resources :student_preferences do 
    	collection do
    		
    		post :collect_pref
    		
    	end
    end
    
    resources :requirements do
    	collection do
    		post :collect_requirements
    	end
    end
  end

  namespace :administrator do

    resources :departments
    resources :section_imports
    resources :white_courses do 
    	collection do
	    	post :update_term
	    	put :ignoreSelectedCourses
	    	put :backSelectedCourses
	        post :cross
	        post :config_constants
	        get :cross_listed
    	end
    
    delete :deleteCross
    	
   end
    
    resources :courses do
    	collection do
    		delete :deleteAllSections
	    	get :editAll
	    	get :deleteSections
	    	post :create
	    	delete :deleteSelectedSections
	    	get :adjustSections
	    	put :adjustSelectedSections 
	    	post :updateSectionsInfo
	    	post :do_update_Sections
    	end
    end
    resources :sections
    resources :email do
      collection do
        post  :sendmail
        end
      end
    resources :keep_users do 
    	collection do
   			 post :addUsers
  		end
    end
    resources :users do
    	collection do
    		delete :destroyAll
    		put :reset
  		end
  	
  	
  		put :wait_list
  		put :off_wait_list
  		put :un_consider

     end
    
    resources :assignments do
    	get :no_stat_edit

      #collection do
        get :send_assignments_CS
        get :send_assignments_non_CS
      #end
    end

    resources :user_imports
    
    get 'settings' => 'settings#index'
    post 'settings/current_term' => 'settings#set_current_term'
    post 'settings/synchronizeGTA' => 'settings#synchronizeGTA'
   	post 'settings/synchronizeIns' => 'settings#synchronizeIns'
    post 'settings/synchronize' => 'settings#synchronize'
    get 'settings/section_preferences_cs' => 'settings#section_preferences_cs'
    get 'settings/section_preferences_ece' => 'settings#section_preferences_ece'
    get 'settings/student_preferences' => 'settings#student_preferences'
    get 'settings/sections' => 'settings#sections'
    get 'settings/gta_template' => 'user_imports#gta_template'
    get 'settings/instructor_template' => 'user_imports#instructor_template'
    get 'settings/sections_template' => 'courses#sections_template'


  end
 
   match "/delayed_job" => DelayedJobWeb, :anchor => false, via: [:get, :post]
end
