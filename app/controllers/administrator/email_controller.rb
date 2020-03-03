module Administrator
	class EmailController < ApplicationController

	 # GET /admin/users/status
	    def index
	            if params[:status] == "all"
	              @users = User.all
	            elsif  params[:status] == "CS_Student"
	              @gta_users = User.where({role: "Student"})
	              		 @users = []
	              		 @gta_users.each do |usr|
	              		 	if usr.major == "CS"
	              		 		 @users.push(usr)
	              		 	end
	              		 end
	            elsif  params[:status] == "ECE_Student"
	              @gta_users = User.where({role: "Student"})
	              		 @users = []
	              		 @gta_users.each do |usr|
	              		 	if usr.major != "CS"
	              		 		 @users.push(usr)
	              		 	end
	              		 end
	            elsif  params[:status] == "Instructor" 
	              @users = User.where({role: "Instructor", consider: true})
	            elsif params[:status] == "sendToMissing" 
	              		@gta_users = User.where({role: "Student"})
	              		 @users = []
	              		 @gta_users.each do |usr|
	              		 	if usr.section_preferences == []
	              		 		 @users.push(usr)
	              		 	end
	              		 end
	            else
	              @users = User.where :role => "Administrator"
	            end  

	            #render :file => 'app\views\administrator\email\index.html.erb'  
   		end

    	def sendmail
		      object = params[:email]
		      recipients = object[:recipient]
		      subject = object[:subject]
		      message = object[:message]
		      #Email.contact(recipient, subject, message).deliver
		      #return if request.xhr?

		      render :text => "Message Sent"
		      Email.welcome_email(recipients, subject , message).deliver
   		end

   	#	def send_assignments
	#	      object = params[:email]
	#	      recipients = object[:recipient]
	#	      subject = object[:subject]
	#	      message = object[:message]
	#	      #Email.contact(recipient, subject, message).deliver
	#	      #return if request.xhr?
#
	#	      render :text => "Message Sent"
	#	      Email.welcome_email(recipients, subject , message).deliver
   	#	end
	end
end
