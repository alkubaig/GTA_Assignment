class SectionPreferencesController < ApplicationController
   before_action :set_student
   before_action :set_sections, only: [:new, :create,:collect_pref ]
   before_action :set_section_preference, only: [:destroy]

  def new
    @section_preference = @student.section_preferences.new
  end

  def create
    @section_preference = @student.section_preferences.new(section_preference_params)

    if @section_preference.save
      redirect_to student_path(@student), notice: 'Section preference was successfully created.'
    else
      render :new
    end
  end

  def destroy
    @section_preference.destroy
    redirect_to student_path(@student), notice: 'Section preference was successfully destroyed.'
  end
 
  def collect_pref	
 		
	 @sections.each do |section |
	 		 		
	 	val = params["prefrence_value"]["#{section.id}"]		
	    unless val == nil
	 		
	 	   @preference = SectionPreference.where(student_id: @student.id, section_id: section.id).take
	 	  	 if @preference == nil
	 	 	  	@preference = @student.section_preferences.create({
	 	  		 section_id: section.id , 
	 	 	 	 value: val
	 	  	  })
	 	 	 else
	 	  		@preference.update_attributes({value: val})
	 	 	 end
	 	 	end	 		
	 	end
	 if @preference.save
     	 redirect_to student_path(@student), notice: 'Section preference was successfully created.'
    else
         redirect_to student_path(@student), alert:  @preference.errors.values.join("','")
	end
  end

  private


def set_student
	@student = User.find(params[:student_id])
end

  def set_section_preference
    @section_preference = SectionPreference.find(params[:id])
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

  def section_preference_params
    params[:section_preference].permit(:section_id, :value)
  end
 
end
