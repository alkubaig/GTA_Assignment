class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
      # You need to implement the method below in your model (e.g. app/models/user.rb)
      @user = User.from_omniauth(request.env["omniauth.auth"])

		@this_email = request.env["omniauth.auth"].info["email"]

		if !@user 
	
	 		redirect_to root_path, alert: "#{@this_email} is not registred in the system. For more info contact Hughes, Calvin Wesley at Calvin.Hughes@oregonstate.edu"

		elsif !@user.consider 
		
			redirect_to root_path, alert: '#{@this_email} is not registred in the system for this term. For more info contact Hughes, Calvin Wesley at Calvin.Hughes@oregonstate.edu'
		
		else
      if @user.persisted?
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
        sign_in_and_redirect @user, :event => :authentication
      else
        session["devise.google_data"] = request.env["omniauth.auth"]
        redirect_to new_user_registration_url
      end
     end
  end
end
