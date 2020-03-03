class Administrator::SectionsController < ApplicationController
	 before_action :set_sections

  def index
 
  end


 
 def set_sections
 	@sections = Section.includes(
        {course: [ :department]},
        {instructor: :student_preferences}, :section_preferences)
        .with_current_term
		.where('courses.ignored = ?', false)
		.where(show: true)
		.order("departments.subject_code ASC,courses.course_number ASC")
	  end

end