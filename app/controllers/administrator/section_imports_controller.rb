module Administrator
	class SectionImportsController < BaseController
  	
 	 def index   		
   	@section_import = SectionImport.new
  end
 
  def new   		
   	@section_import = SectionImport.new
  end
 
 def create
    @section_import = SectionImport.new(params[:section_import])
    
    if @section_import.save
    	update_Sections
      redirect_to editAll_administrator_courses_path, notice: "Imported sections successfully."
    else    	
    	 redirect_to editAll_administrator_courses_path, alert: "Error: " + @section_import.errors.full_messages.join(', ').html_safe 
    end
   
  end
 
  def update_Sections
  		@sections = Section.all
		@sections.each do |s|
			s.update_sections
		end
  end
 
 	 def user_params
        params[:section_import].permit(:file)
      end
     
     end
 end