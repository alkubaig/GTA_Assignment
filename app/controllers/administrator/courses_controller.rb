require 'get_section_info'

module Administrator
	class CoursesController < BaseController
		  before_action :set_curre_term
		  before_action :set_sections 
		  before_action :set_all_sections, only: [:updateSectionsInfo]

	
  	def index	
  		@current_term = Setting.current_term
  		@terms = Section.select("DISTINCT term").map { |s| [s.term, s.term] }
  		
  		 
  		
			if @current_term.start_with?( 'F')
			  @select_term = 'fall'
			elsif @current_term.start_with?( 'W')
			  @select_term = 'winter'
			elsif @current_term.start_with?( 'Sp')
			  @select_term = 'spring'
			else
			   @select_term = 'summer'
			end
		
		
			@select_year = Date.strptime(@current_term.scan( /\d+$/ ).first, '%y').strftime("%Y")
		
		
  		
  		
  	end
  
#   def editAll
#   	
#   update_Sections()	 
# 
#   end
 
	 def do_update_Sections
	 	
	 	update_Sections()
	 	redirect_to editAll_administrator_courses_path, notice: 'Sections merged successfully.'

 	
 	end
    
  def updateSectionsInfo
	
  	 problem = GetSectionInfo.new(@sections )
     problem.solve
          result = problem.res
          lecture = nil
          result.each do |res|
          	
          	if res.type == "Laboratory" && lecture != nil
          		 labs = lecture.num_labs + 1
          		 lecture.update_attributes({num_labs: labs })

          	else
          		lecture = nil
          	end
          	
          	 mysection = Section.where({crn: res.crn, term: res.term  }).take
          	 if mysection != nil
          	 	 mysection.update_attributes({max_enrollment: res.capacity, current_enrollment: res.current, location: res.campus, num_labs: 0 })
          	 	 lecture = mysection
          	 end 
          end
   
  		redirect_to editAll_administrator_courses_path, notice: 'Section was successfully added.'

  	end
  
    def update_Sections
  		@update_sections = Section.all
		@update_sections.each do |s|
			s.update_sections	
		end
  end
 
  
  def sections_template
      respond_to do |format|
        format.xlsx
      end
   end
   
  def adjustSelectedSections
  	
  	 params["section"]["major"].each do |sec |
  	 	
  	 	 option = sec.split("-").first
  	 	 id = sec.split("-").last
  	 	 section = Section.includes(course: [:department]) .with_current_term.find(id)
  	 	 section.course.update_attributes({ta_major: option })
   	 	   	 
   	 end
  
   	@sections.each do |sec|
  
   		num_ta =  params["section"]["ta"]["#{sec.id}"]
   		section = Section.find(sec.id)
   		section.update_attributes({num_ta: num_ta })
   		
   		instructor_id =  params["section"]["instructor_id"]["#{sec.id}"].to_i
   		
   		instructor = User.where(osu_id: instructor_id).first || User.create(osu_id: instructor_id, first_name: "Staff", last_name: "Staff")
   		
   			section.update_attributes({instructor_id: instructor.id })
   	

   		
   	end
   
   
   
  	
  	redirect_to adjustSections_administrator_courses_path, notice: 'Section were successfully updated.'
  	
  end
 
  def deleteSelectedSections
           	
     if params["course"] != nil
     	
	   	 params["course"]["section_id"].each do |id |
	   	 	
	   	 	Section.find(id).student_preferences.destroy_all
	   		Section.find(id).section_preferences.destroy_all
	   	 	section = Section.find(id).destroy	 
	   	 end
	   	
	   	 redirect_to editAll_administrator_courses_path, notice: 'Sections successfully deleted.'
   	else
    redirect_to editAll_administrator_courses_path, notice: 'No sections to be deleted.'

	end
  end
  
 
  def deleteAllSections
  	
  	StudentPreference.destroy_all
	SectionPreference.destroy_all
  	Section.destroy_all 
  	redirect_to editAll_administrator_courses_path, notice: 'Sections successfully deleted.'

  end

   def create
   	 
   		if params[:department].empty? || params[:course_number].empty? || params[:location].empty? || params[:term].empty? || params[:cc_instructor_tag].empty?  || params[:current_enrollment].empty?
   	 		
   	 		 redirect_to editAll_administrator_courses_path, alert: 'Course can not be empty; fill all required fields'
		else
   	
   			case params[:ta_major]
   				
   				when 0
   					@ta_major = "ECE"
   				when 1
   					@ta_major = "CS"
   				when 2
   					@ta_major = "ECE/CS"
   			end

		   	@course = Course.where(course_number: params[:course_number]).take
		   	@department = Department.where(subject_code: params[:department]).take
			if  @course == nil
				@course = Course.create({
					
					department: @department,
					course_number: params[:course_number],
					ta_major: @ta_major
					
					})
			end		 
		   	 Section.create({
		        cc_instructor_tag: params[:cc_instructor_tag],
		        term: params[:term] ,
		        location: params[:location],
		        current_enrollment: params[:current_enrollment] ,
		        course: @course
		        
		      })
		      
		      redirect_to editAll_administrator_courses_path, notice: 'Section was successfully added.'
	      end
    end
 
   def set_curre_term
        @curr_term = Setting.current_term
   end
     
   def set_all_sections
        @sections = Section.includes(
	        course: [:department])  
	 .with_current_term
	 .where('courses.ignored = ?', false)
	 .order("departments.subject_code ASC,courses.course_number ASC")
    end
   
    def set_sections
        @sections = set_all_sections.where(show: true)
    end
  
   end
end
