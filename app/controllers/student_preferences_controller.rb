class StudentPreferencesController < ApplicationController
  before_filter :set_section
  before_filter :set_students, except: [:destroy]
  before_filter :set_skills

  def new
    @preference = current_user.student_preferences.new
  end
 
 
 def collect_pref	
 		
	 @students.each do |student |
	 		 		
	 	val = params["prefrence_value"]["#{student.id}"]		
	    unless val == nil
	 		
	 	   @preference = StudentPreference.where(student_id: student.id, instructor_id: @section.instructor.id, section_id: @section.id).take
	 	  	 if @preference == nil
	 	 	  	@preference = @section.instructor.student_preferences.create({
	 	  		 section_id: @section.id , 
	 	 	 	 value: val,
	 	 	 	 student_id: student.id
	 	 		  })
	 	 	 else
	 	  		@preference.update_attributes({value: val})
	 	 	 end
	 	 	end	 		
	 	end
	 
	  if @preference.save
     	 redirect_to section_path(@section)
    else
         redirect_to section_path(@section), alert:  @preference.errors.values.join("','")
	end
	     
  end

  def create
  	
  	@preference = @section.instructor.student_preferences.new(student_preference_params)
   # @preference = current_user.student_preferences.new(student_preference_params)
    @preference.section_id = @section.id

    if @preference.save
      redirect_to section_path(@section)
    else
    redirect_to section_path(@section), alert: 'You already added this student in preferences.'
     # render "new"
    end
  end

  def destroy
    @preference = StudentPreference.find(params[:id])
    @preference.destroy
    redirect_to section_path(@section), notice: 'Student preference was successfully destroyed.'
  end

  private

  def student_preference_params
    params[:student_preference].permit(:student_id, :value)
  end

  def set_section
    @section = Section.find(params[:section_id])
  end

  def set_students
   # @students = User.gtas
    @students = User.where(role: "Student", consider: true)
  end

  def set_skills
    @skills = Skill.all
  end

end
