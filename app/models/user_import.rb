class UserImport
  
  include ActiveModel::Model

  attr_accessor :file, :status

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def persisted?
    false
  end
  
  def save 
  	isValid  = true
  	spreadsheet = open_spreadsheet
    header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
	    row = Hash[[header, spreadsheet.row(i)].transpose]
	    
	      
	    sheetEmails = row["Email"].split(",")
	    emails = []
	    id = row["SID"].to_i
	      
     sheetEmails.each do |email|
	         if (email.downcase.split('@').last != "oregonstate.edu")         
	                  errors.add :base, "fix email: #{email}"
	                  isValid = false
	          end
	   end
	  
	 	 first_name = row["First Name"]
		last_name = row["Last Name"]
		
		if first_name && last_name 
				
			first_name = row["First Name"].rstrip
			last_name = row["Last Name"].lstrip
		end
	  
	  	@user = User.where(osu_id: id ).first || User.create(osu_id: id, first_name: first_name, last_name: last_name)

    
      if  (! id)         
                 errors.add :base, "Enter OSU id"
                 isValid = false
                 
      elsif ( ! @user.save)   
      	
      	  errors.add :base, "User failed #{id}"
          isValid = false
      	          
      elsif ( isValid)
        
        sheetEmails.each do |email|             
             findEmail = Gemail.find_for_authentication(email: email.downcase) || Gemail.create(email:  email.downcase )
             emails.push(findEmail)
       end
        
                      
			is_wait_list = row["Wait_list"] ? row["Wait_list"].downcase : false
			
			 
			fte = row["FTE"]
			
			case fte
				 when 0.49
					fte = 0.5
				 when 0.24
				 	fte = 0.25
			end
		
			
					
	 		@user.update_attributes({
	 		    osu_id: id,
	       	first_name: first_name,
	     	   last_name: last_name,
	       		fte: fte,
	       	 role: self.status,
	       	 cc_instructor_tag: "#{last_name}, #{first_name[0]}.",
	       	 major: row["Major"],
	       	 is_wait_list: is_wait_list,
	       	 consider: true

	     	 })
	     	 
        emails.each do |email|
          email.update_attributes(user_id: @user.id)
        end

	     	 @imported_users = @user
	     end 
	   end
	  isValid 
	end

 
  def open_spreadsheet
    case File.extname(file.original_filename)
   # when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
   # when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
    else raise "Unknown file type use .xlxs: #{file.original_filename}"
    end
  end
end