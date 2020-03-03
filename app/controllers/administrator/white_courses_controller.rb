module Administrator
	class WhiteCoursesController < BaseController
		  before_action :set_courses
 
 	def ignoreSelectedCourses
 		
 		params["course"]["section_id"].each do |id |
   	 	
   	 	  @ingored = Course.find(id)
          @ingored.update_attributes({ignored: true })
         
          delete_sections = Section.where(course: @ingored )
          
          delete_sections.each do |delete|
          	
          	delete.student_preferences.destroy_all
          	delete.section_preferences.destroy_all
          end
          
          delete_sections.destroy_all
       end
  	
  	      	redirect_to administrator_white_courses_path, notice: 'Courses were successfully ignored.'

 	end
 	
 	
	 def backSelectedCourses
	 	
	 	params["course"]["section_id"].each do |id |
   	 	
   	 	 Course.find(id).update_attributes({ignored: false })
   	 	   	 
   		 end
  	
      	redirect_to administrator_white_courses_path, notice: 'Courses were successfully added to white-list.'
	 	
	end
   
   def select_term_method (term, year)
   	
   	   	selected_year =	Date.strptime(year, '%Y').strftime("%y")
   	   	
	   	puts case term
			when "winter"
	  			selected_term = "W" 
			when "fall"
	  			selected_term = "F" 
			when "summer"
	  			selected_term = "Su" 
			else
	  			selected_term = "Sp"
	
		end
	   	
   		Setting.current_term = "#{selected_term}#{selected_year}"
   		
   		#Section.where.not(term: Setting.current_term).destroy_all
   		#sync
   	
   		Setting.current_term 
   	
   	end
   
   def update_term
   	
   	term =  params[:term]
   	year =  params[:year]
   	
	selected_term = select_term_method(term, year)
   	school_term =  term + year
   
   	 redirect_to administrator_settings_path, notice: 'Term successfully updated'
   	end
   
   def deleteCross
   	
   	   	current_cross_listed = Setting.cross_listed
   	   	
 		pass = params[:white_course_id].split("//")
 		pass[pass.size - 1] = pass[pass.size - 1].split("/")[0]  
 		
 		pass = pass.map{|s| "#{s}/"}	   	
   	   	
   	   	puts ":current_cross_listed #{current_cross_listed}"
   	   	puts ":white_course_id #{pass}"
   		current_cross_listed.delete(pass)
   		Setting.cross_listed = current_cross_listed
   		 redirect_to cross_listed_administrator_white_courses_path
   	
   end
  
  def cross_listed
  	
  		@s = []
   		cross_listed = Setting.where(var: "cross_listed").take
 		if cross_listed == nil 
   		   	@s = Setting.create({var: "cross_listed", value: []}).value
   		else
	   		@s = cross_listed.value
	   	end
	   	
	   #update_Sections()
  	
  end
   
   def index
	   
	   constants()
   end
  
  def update_Sections
  		@sections = Section.all
		@sections.each do |s|
			s.update_sections	
		end
  end
   
   	def cross
   	
   		cross_listed = []
   		cross_listed_courses = []


		if params["course"].count == 1
			
			redirect_to cross_listed_administrator_white_courses_path, alert: 'Select more than one course'
			return 	
		
		end 
	
			current_cross_listed = Setting.where(var: "cross_listed").take.value
	
			params["course"].each do |c|	
	   			cross_listed.push(c)
	   			current_cross_listed.each do |s|
	   				s.each do |ss|
	   					if  ss == c 
	   						redirect_to cross_listed_administrator_white_courses_path, alert: 'Course already selected' 
	   						return 	
	   					end
	   				end 
	   			end
			end	

   			current_cross_listed.push(cross_listed)
   		 	Setting.cross_listed = current_cross_listed
   			redirect_to cross_listed_administrator_white_courses_path

   	end
 
    def set_courses
        @courses = @courses = Course.all
    end
   
   
   def constants
   		
	   	 st_ta = Setting.where(var: "students_per_ta" ).take
	   	if 	st_ta == nil
	   		st_ta = Setting.create({var: "students_per_ta", value: 30})
	   	end
	   
	   @students_per_ta =  st_ta.value
	   
		cut_off = Setting.where(var: "round_cut_off" ).take 
		if cut_off == nil
	   			cut_off = Setting.create({var: "round_cut_off", value: 15})
	   	end
	   
	   @round_cut_off = cut_off.value
   end
  
   def config_constants
   	
   		st_ta = Setting.where(var: "students_per_ta" ).take
   		st_ta.update_attributes({value: params["students_per_ta"].to_i })

   		cut_off = Setting.where(var: "round_cut_off" ).take 
   		
   		if params["students_per_ta"].to_i < params["round_cut_off"].to_i
   			redirect_to administrator_white_courses_path, alert: 'The number we round at must be less than or equal to the number of students per TA'
		else
   			cut_off.update_attributes({value: params["round_cut_off"].to_i })
   	   		redirect_to administrator_white_courses_path
		end
   end
  
  end
end
