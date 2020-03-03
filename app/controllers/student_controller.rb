class StudentController < ApplicationController
	
 def show
    @student = User.find(params[:id])
    @section_preferences =   @student.section_preferences.with_current_term
    @experiences =   @student.experiences

  end
	
end
