class Administrator::StudentsController < ApplicationController
	 before_action :set_students

  def index
 
  end

  def edit
 	@userid = params[:id]
 	@user = User.find(@userid)
    @section_preferences = @user.section_preferences.with_current_term
    @experiences = @user.experiences
 
  end
 
  def set_students
 	@students = User.where(role: "Student", consider: true)
	  end

end