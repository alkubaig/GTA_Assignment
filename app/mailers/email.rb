class Email < ApplicationMailer
	#def contact(recipient, subject, message, sent_at = Time.now)
      #@subject = subject
      #@recipients = recipient
      #@from = 'gta.assignments@gmail.com'
      #@sent_on = sent_at
      #@body["title"] = 'This is title'
      #@body["email"] = 'sender@yourdomain.com'
     # @body = message
    #  @headers = {}
   #end


  default :from => "gta.assignments@gmail.com"

   def welcome_email(list, subject, body)
      #The line below is only commented out to prevent accidentally emailing all of the GTA's and Professors, when uncommented, it works!
      mail(:to => list, :cc => "calvin.hughes@oregonstate.edu", :subject => subject, :body => body)
   end

   #handle_asynchronously :welcome_email
end

   