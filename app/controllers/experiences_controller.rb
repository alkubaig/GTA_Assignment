class ExperiencesController < ApplicationController
  before_action :set_experience, only: [:show, :destroy]
  before_filter :set_skills
   before_action :set_student

  def new
    @experience = @student.experiences
  end

 def collect_experiences
 	
 	if params["skill_value"] == nil
 			 #render "new"
 			   redirect_to new_student_experience_path(@student), alert: 'No Experiences added.'

		else
      		redirect_to student_path(@student), notice: 'Experience was successfully created.'
		
 		 @skills.each do |skill|
 			val = params["skill_value"]["#{skill.id}"]		
	   		unless val == nil
	   			
	   			@exp =  @student.experiences.where(skill_id: skill.id , student_id: @student.id).take
	   			
	   			if @exp  == nil
	   				
	   				@student.experiences.create({skill_id: skill.id, value: val })
	   				
	   			else
	   				
	   				@exp.update_attributes({value: val})
	   				
	   			end
	   			
	   		end
		 end
 	
 		end

	
 end

  def create
    @experience = @user.experiences.new(experience_params)

    if @experience.save
      redirect_to student_path(@student), notice: 'Experience was successfully created.'
    else
      render :new
    end
  end

  def destroy
    @experience.delete
    redirect_to student_path(@student), notice: 'Experience was successfully destroyed.'
  end

  private

  def set_experience
    @experience = Experience.find(params[:id])
  end

 def set_skills
 	    @skills = Skill.all
 end

  def experience_params
    params[:experience].permit(:skill_id, :value)
  end
 
 
 def set_student
 	@student = User.find(params[:student_id])
 	end
end
