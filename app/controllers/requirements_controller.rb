class RequirementsController < ApplicationController
  before_filter :set_section
  before_filter :set_skills


  def new
    @requirement = Requirement.new

  end
 
 
 	def collect_requirements
 		
 		if params["skill_value"] == nil
 			 render "new"

		else
			redirect_to section_path(@section)
		
 		 @skills.each do |skill|
 			val = params["skill_value"]["#{skill.id}"]		
	   		unless val == nil
	   			
	   			@requirement = @section.requirements.where(skill_id: skill.id , section_id: @section.id).take
	   			
	   			if @requirement  == nil
	   				
	   				Requirement.create({skill_id: skill.id ,value: val, section_id: @section.id, instructor_id: @section.instructor.id })
	   				
	   			else
	   				
	   				@requirement.update_attributes({value: val})
	   				
	   			end
	   			
	   		end
		 end
 	
 		end

 	end
 
  def create
    @requirement = Requirement.new(requirement_params)
    @requirement.section_id = @section.id
    @requirement.instructor_id = @section.instructor.id

    if @requirement.save
      redirect_to section_path(@section)
    else
      render "new"
    end
  end

  def destroy
    @requirement = Requirement.find(params[:id])
    @requirement.destroy
    redirect_to section_path(@section), notice: 'Requirement was successfully destroyed.'
  end

  private

  def requirement_params
    params[:requirement].permit(:skill_id, :value)
  end

  def set_section
    @section = Section.find(params[:section_id])
  end
 def set_skills
 	    @skills = Skill.all
end
end
