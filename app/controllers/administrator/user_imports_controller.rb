module Administrator
  class UserImportsController < BaseController
  	
  	def gta_template
      respond_to do |format|
        format.xlsx
      end
    end
   
   def instructor_template
      respond_to do |format|
        format.xlsx
      end
    end
   
   def index 
   	
   	if @user_import == nil
   		
   		@user_import = UserImport.new
   		end
   	end
   
  def new   		
   	@user_import = UserImport.new
  end

  def create
    @user_import = UserImport.new(params[:user_import])
    
    if @user_import.save
      redirect_to administrator_users_path(:status => @user_import.status), notice: "Imported users successfully."
    else


          redirect_to administrator_users_path(:status => @user_import.status), alert: "Errors:  " + @user_import.errors.full_messages.join(', ').html_safe 
        #  render :new
    end
  end
 
  def user_params
        params[:user_import].permit(:file, :status)
      end
end
end