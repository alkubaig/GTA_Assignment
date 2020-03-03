module Administrator
  class SettingsController < BaseController
  	before_action :set_sections
  	
   def set_sections
 	@sections = Section.includes(:section_preferences , course: [:department])
   	  .with_current_term      
      .order("departments.subject_code ASC,courses.course_number ASC")
      .where('courses.ignored = ?', false)
      .where(show: true)
 	end

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

  #  def set_current_term
   #   Setting.current_term = params[:current_term]
    #  redirect_to administrator_courses_path, notice: 'Term was successfully updated.'
    #end
   
     def synchronizeGTA
   	
   	  GtaSyncJob.perform_now
      redirect_to administrator_settings_path
   	end
    def synchronizeIns
   	
   	  InsSyncJob.perform_now
      redirect_to administrator_settings_path
   		
   	end
    def synchronize
      DepartmentsSyncJob.perform_now
      redirect_to editAll_administrator_courses_path, notice: 'courses were successfully imported.'
    end
   
   def sections
   	 @user = User.all
   	end

  	def section_preferences_cs
      @students = User.gtas.where(major: "CS")

      respond_to do |format|
        format.xlsx
      end
    end
   
   	def section_preferences_ece
      @students = User.gtas.where(major: "ECE")

      respond_to do |format|
        format.xlsx
      end
    end

    def student_preferences
      @students = User.gtas

      respond_to do |format|
        format.xlsx
      end
    end
  end
 

 
end
