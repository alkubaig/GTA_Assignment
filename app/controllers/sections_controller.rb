class SectionsController < ApplicationController

  before_filter :set_students, except: [:destroy]

  def index
    @sections = current_user.sections.with_current_term.where(show: true)
  end

  def show
    @section = Section.find(params[:id])
    @preference = current_user.student_preferences.new

  end
 
 
	def comment
 	
 		Section.find(params[:section_id]).update_attributes(comment: params['comment']['text'] )

 	    redirect_to :back, notice: 'comment submitted successfully'

 	end
     
   	def set_students
    	#@students = User.gtas
        @students = User.where(role: "Student", consider: true)

 	 end
 	
 	
 	
end
