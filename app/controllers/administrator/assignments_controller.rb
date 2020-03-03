require 'integer_linear_program'
require 'solve_problem_job'

SolveProblemJob

module Administrator
  class AssignmentsController < BaseController
    before_action :set_students, only: [:new, :create, :update, :show,:no_stat_edit]
    before_action :set_sections, only: [:new, :create, :update, :show,:no_stat_edit,:send_assignments_CS,:send_assignments_non_CS]
    before_action :set_cut_off, only: [ :edit, :update, :show,:no_stat_edit]
    before_action :set_student_per_ta
    
    before_action :set_cs_students, only: [ :edit,:no_stat_edit,:send_assignments_CS,:send_assignments_non_CS]
    before_action :set_ece_students, only: [:edit,:no_stat_edit,:send_assignments_CS,:send_assignments_non_CS]
    before_action :set_cs_sections, only: [ :edit,:no_stat_edit]
    before_action :set_ece_sections, only: [ :edit,:no_stat_edit]

    def index
      @assignments = Assignment.order(created_at: :desc)
      @assignment = Assignment.new
      @assignments_fte = {}
      @assignments_is_fixed = {}

    end
   
   
   def destroy
   		Assignment.find(params[:id]).destroy
   		redirect_to administrator_assignments_path
   	end

    def new
      @assignment = Assignment.new
      @assignments_fte = {}
      @assignments_is_fixed = {}
     
      @doubles = []
      @ftes = []
   	@students.each do |student|
    		
    		if student.is_wait_list 
    			
    			@ftes.push(0)
          		@doubles.push("wait_list")
    		else
    			@doubles.push("")
    			@ftes.push("")
    		end
    	end
      	
    end

    def edit
      @assignment = Assignment.find(params[:id])
      @assignments_fte = @assignment.assignments_fte
      @assignments_is_fixed = @assignment.assignments_is_fixed
            
      set_doubles

    end
   
   def no_stat_edit
   	
   	 @assignment = Assignment.find(params[:assignment_id])
      @assignments_fte = @assignment.assignments_fte
      @assignments_is_fixed = @assignment.assignments_is_fixed

   	
   	end

    def create
    	
    redirect_to administrator_assignments_path

      @assignments_fte = params[:assignments_fte] || {}
      @assignments_is_fixed = params[:assignments_is_fixed] || {}
      @missing_fte = params[:missing_fte].to_f || 0.0


      if params[:commit] == "Run solver"
      	
      	#SolveProblemJob.perform_later(@students.to_json,@sections.to_json, @assignments_fte.to_json, @assignments_is_fixed.to_json )
        begin
          problem = ::IntegerLinearProgram.new(@students.gtas_approved, @sections, @assignments_fte, @assignments_is_fixed, {}, false)
          problem.solve
          @assignments_fte = problem.results
          #problem.print_results

        rescue RuntimeError
          flash[:alert] = "Infeasible solution"
        end
      end

     @assignment = Assignment.create( assignments_fte: @assignments_fte, assignments_is_fixed: @assignments_is_fixed)
#      redirect_to administrator_assignment_path(@assignment)
    end

    def update
    	   	  
   	  previous_assignments = Assignment.find(params[:id]).assignments_fte || {}
      @assignments_fte = params[:assignments_fte] || {}
      @assignments_is_fixed = params[:assignments_is_fixed] || {}
      @allow_double_ass = params[:assignment]["allow_double_ass"]
      
      submitted_assignments = submit_assignments( @assignments_fte, previous_assignments, @assignments_is_fixed )
      
    #  redirect_to administrator_assignments_path

      if params[:commit] == "Run solver"      	
        begin
        	
          problem = ::IntegerLinearProgram.new(@students.gtas_approved, @sections, submitted_assignments, @assignments_is_fixed ,  @allow_double_ass)
          problem.solve
          submitted_assignments = problem.results

        rescue RuntimeError
          flash[:alert] = "Infeasible solution"
        end
      end

      @assignment = Assignment.create(
        assignments_fte: submitted_assignments, assignments_is_fixed: @assignments_is_fixed, allow_double_ass: @allow_double_ass)
      redirect_to edit_administrator_assignment_path(@assignment)
      
    end

    def show
   		
      @assignment = Assignment.find(params[:id])
      @assignments_fte = @assignment.assignments_fte
      @assignments_is_fixed = @assignment.assignments_is_fixed

     # set_doubles

      respond_to do |format|
        format.html
        format.txt  { render 'show.txt.erb' }
        format.xlsx { render xlsx: 'show.xlsx.axlsx' }
      end
    end

    def send_assignments_CS
          subject = "Your GTA Assignment"
            
          @assignment = Assignment.find(params[:assignment_id])
          @assignments_fte = @assignment.assignments_fte

          has_assignment = false
          @cs_students.each do |student|
              has_assignment = false
              message = "Hello " + student.full_name + ",\n\n" 
            @sections.each do |section|
              if @assignments_fte["#{student.id}_#{section.id}"] && @assignments_fte["#{student.id}_#{section.id}"] > 0 and student.major == "CS" then
                assigned_course =  "#{section.merge_label} - #{section.section_name}"
                message += "For " + section.term + " term you are assigned:\n" + @assignments_fte["#{student.id}_#{section.id}"].to_s + " FTE to: " +
                            assigned_course + " (CRN: " + (section.crn).to_s + ")\n" 
                has_assignment = true
              end
            end
            if(has_assignment) then
              message += "\nIf you have any questions, please contact Dr. Tadepalli at Tadepall@oregonstate.edu.\n\n Thank you"
              #For Testing
              #recipients = "burnettn@oregonstate.edu"
              #To actually send TA Emails
              recipients = student.email #"ghadeeralkubaish@gmail.com" 
              Email.welcome_email(recipients, subject , message).deliver
            end
          end
   		 redirect_to administrator_assignments_path

    end

    def send_assignments_non_CS
          subject = "Your GTA Assignment"
            
          @assignment = Assignment.find(params[:assignment_id])
          @assignments_fte = @assignment.assignments_fte

          has_assignment = false
          @ece_students.each do |student|
              has_assignment = false
              message = "Hello " + student.full_name + ",\n\n" 
            @sections.each do |section|
              if @assignments_fte["#{student.id}_#{section.id}"] && @assignments_fte["#{student.id}_#{section.id}"] > 0 and student.major != "CS" then
                assigned_course =  "#{section.merge_label} - #{section.section_name}"
                message += "For " + section.term + " term you are assigned:\n" + @assignments_fte["#{student.id}_#{section.id}"].to_s + " FTE to: " +
                            assigned_course + " (CRN: " + (section.crn).to_s + ")\n" 
                has_assignment = true
              end
            end
            if(has_assignment) then
              message += "\nIf you have any questions, please contact Dr. Tadepalli at Tadepall@oregonstate.edu.\n\n Thank you"
              #For Testing
              #recipients = "burnettn@oregonstate.edu"
              #To actually send TA Emails
              recipients = student.email #"ghadeeralkubaish@gmail.com" 
              Email.welcome_email(recipients, subject , message).deliver
            end
          end
    	redirect_to administrator_assignments_path

    end  

    private
    
    
    def submit_assignments(assignments_fte, previous_assignments, assignments_is_fixed )
   	
   	   	fix_assignments = previous_assignments
 
	   	assignments_is_fixed.each do |key, value|
	      student_id, section_id = key.split("_")
	      
	      if ! assignments_fte["#{student_id}_#{section_id}"] 
	      	     fix_assignments[:"#{student_id}_#{section_id}"] = previous_assignments["#{student_id}_#{section_id}"]
		  else
		  		  fix_assignments[:"#{student_id}_#{section_id}"] = assignments_fte[:"#{student_id}_#{section_id}"]

	      end
	     
		end
	
   		return fix_assignments
   	end
   
    def set_cut_off
    	cut_off = Setting.where(var: "round_cut_off" ).take 
	 	@round_cut_off = cut_off  == nil ? 15.0 : cut_off.value.to_f
	 	@round = @round_cut_off / 100.0
    end
    def set_student_per_ta
    	 st_ta = Setting.where(var: "students_per_ta" ).take
		 @students_per_ta = Setting.where(var: "students_per_ta" ).take == nil ? 30.0 : st_ta.value.to_f
    end
   
   
   def set_cs_students
   	 @cs_students = User.includes([{section_preferences: :section}, :experiences]).cs_students
   	end


	def set_ece_students
	  @ece_students = User.includes([{section_preferences: :section}, :experiences]).ece_students
	end


	def set_cs_sections
	   	 @cs_sections = Section.includes(
		        {course: [:department]},
		        {instructor: :student_preferences}, :section_preferences)
		        .with_current_term
		        .order("departments.subject_code ASC,courses.course_number ASC")
		       	.where('courses.ignored = ?', false)
		       	.where(show: true).where("departments.subject_code =?", "CS")

	end

	def set_ece_sections
	   	 @ece_sections = Section.includes(
		        {course: [:department]},
		        {instructor: :student_preferences}, :section_preferences)
		        .with_current_term
		        .order("departments.subject_code ASC,courses.course_number ASC")
		       	.where('courses.ignored = ?', false)
		       	.where(show: true).where.not("departments.subject_code =?", "CS")

	end



    def set_sections
    	
    	@sections = Section.includes(
		        {course: [:department]},
		        {instructor: :student_preferences}, :section_preferences)
		        .with_current_term
		        .order("departments.subject_code ASC,courses.course_number ASC")
		       	.where('courses.ignored = ?', false)
		       	.where(show: true)
		      
    end
   
   def set_students
   	  @students = User.includes([{section_preferences: :section}, :experiences]).where(role: "Student", consider: true)
   	
   	end
    	
=begin    	
    	
    	    def set_students

    	if params[:status] == "cs" 
    	
    	  @students = User.includes([{section_preferences: :section}, :experiences])
     	 .where(role: "Student").cs_students_first
     	 
     	 else 
     	 	
     	 		  @students = User.includes([{section_preferences: :section}, :experiences])
     	 .where(role: "Student").ece_students_first
     	 
     	 end  
     	
     	end    



    def set_sections
   	
   		if params[:status] == "cs" 
   			
		      @sections = Section.includes(
		        {course: [:department]},
		        {instructor: :student_preferences}, :section_preferences)
		        .with_current_term
		        .order("departments.subject_code ASC,courses.course_number ASC")
		       	.where('courses.ignored = ?', false)
		       	.where(show: true)
       	
       else 
       	
		       	 @sections = Section.includes(
		        {course: [:department]},
		        {instructor: :student_preferences}, :section_preferences)
		        .with_current_term
		        .order("departments.subject_code DESC,courses.course_number ASC")
		       	.where('courses.ignored = ?', false)
		       	.where(show: true)


		end
	
	    end
   # 	.where.not('courses.ta_major = ?', "ECE")

       	
       # .where('current_enrollment >= ?', 30)
	
=end
 
   
   def set_doubles	
 	    @doubles = []
 	    
 	    temp_students = @cs_students
		
	    (1..2).each do |f| 

	 		temp_students.each do |student|
	 			
	 			if ! student.is_wait_list
					k = 0 
					stud_fte = 0 
					
					sections = @cs_sections + @ece_sections
         
		            sections.each do |section| 
		            	if @assignments_fte["#{student.id}_#{section.id}"].to_f > 0
		            		stud_fte += @assignments_fte["#{student.id}_#{section.id}"].to_f.round(2)
		            		k +=1
		            	end
		           end
		          
				 case k 
				 	when 0
				 		   @doubles.push("danger")
				 	when 1
				 		  if stud_fte == student.fte
				 		  	 @doubles.push("success") 
				 		  	else
				 		  		@doubles.push("info")
				 		  end
				 	else
				 	      @doubles.push("warning") 
				 	end
	          	
	          else
	          	
	          	@doubles.push("wait_list")
	          	end
	         end
	         temp_students = @ece_students

	    end

	   end
   
   
   
   
  end
 
end
