module Administrator
  class UsersController < BaseController
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    before_action :set_user_, only: [:wait_list, :off_wait_list,:un_consider]



    # GET /admin/users/status
    def index
            if params[:status] == "all"
               @users = User.all
            elsif  params[:status] == "Student"
              @users = User.where( role: "Student", consider: true )
              elsif  params[:status] == "Instructor" 
              @users =User.where( role: "Instructor", consider: true )
            else
              @users = User.where :role => "Administrator"
            end 
                     
              
    end

    # GET /admin/users/1
    def show
    end

    # GET /admin/users/new
    def new
      @user = User.new
    end

    # GET /admin/users/1/edit
    def edit
    end
   
   	def wait_list
   		
   		@user.update_attributes({is_wait_list: true})
   		redirect_to administrator_users_url(@user, :status => @user.role), notice: 'User was successfully put in wait-list.'

   	end
   
   	def off_wait_list
   		
   		@user.update_attributes({is_wait_list: false})
   		redirect_to administrator_users_url(@user, :status => @user.role), notice: 'User was successfully taken off the wait-list.'

   	end
   
   

    # POST /admin/users
    def create
      @user = User.new(user_params)

      if @user.save
        redirect_to administrator_users_url(@user, :status => @user.role), notice: 'User was successfully created.'
      else
        render :new
      end
    end
    
    # PATCH/PUT /admin/users/1
    def update
    	
    	if @user.role == "Administrator"
    		@user.is_administrator = true
    	end
    		
    	
      if @user.update(user_params)
      	 stat = @user.role
      	if @user.notRegistred
      		stat = "all"
     	 end
        redirect_to administrator_users_url(@user, :status => stat), notice: 'User was successfully updated.'
      else
        render :edit
      end
    end
   
    def reset
   	
   	@users = User.where :role => params[:status]
   	@users.each do |user|
   		    user.update({consider: false})
   	end
    redirect_to administrator_users_url(:status =>params[:status]), notice: 'Sucessful Reset.'

   end
  
   def destroyAll
   	
  
   	@users = User.where :role => params[:status]
   	@users.each do |user|
   		    user.section_preferences.destroy_all
     	    user.student_preferences.destroy_all
     	    user.gemails.destroy_all
   			user.destroy
   	end
    redirect_to administrator_users_url(:status =>params[:status]), notice: 'Users were successfully destroyed.'

   end
    
    def un_consider
    	
   	@user.update({consider: false})
    redirect_to administrator_users_url(:status => @user.role), notice: 'User was successfully ignored.'

   	end
   
    # DELETE /admin/users/1
    def destroy
   
      
     StudentPreference.all.each do |student_preference|
        if student_preference.student.id ==  @user.id
        	 student_preference.destroy
        end
      end
        	
      
      stat = @user.role
      if @user.notRegistred
      	stat = "all"
      end
     
      @user.section_preferences.destroy_all
      @user.student_preferences.destroy_all
      @user.destroy 
      
      redirect_to administrator_users_url(:status => stat), notice: 'User was successfully destroyed.'
      
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_user
        @user = User.find(params[:id])
      end
     
       def set_user_
        @user = User.find(params[:user_id])
      end

      # Only allow a trusted parameter "white list" through.
      def user_params
        params.require(:user).permit(:osu_id, :is_administrator, :fte , :first_name, :last_name, :role, :is_wait_list, :major, :consider, :gemails_attributes => [:id, :user_id, :email , :done, :_destroy])
      end
  end
end
