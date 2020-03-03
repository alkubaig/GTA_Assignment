class SectionImport
  
  include ActiveModel::Model  
  
  attr_accessor :file
    
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
	   
	   	    ##################################### 	    

	   #add the intructor
	      
	  sheetEmails = row["Email"] ? row["Email"].split(",") : []
      emails = []
      id = row["Instructor ID"].to_i  
       
      sheetEmails.each do |email|
            
            if (email.downcase.split('@').last != "oregonstate.edu")         
                   errors.add :base, "fix email: #{email}"
                   isValid = false
            end
      end
		first_name = row["first_name"]
  		last_name = row["last_name"]
  		
  		if first_name == nil && last_name == nil
  				
  				name = row["Instructor Name"]
  				first_name = name.split(", ").last
  				last_name = name.split(", ").first
  
  		else
  				first_name = row["first_name"].rstrip
  				last_name = row["last_name"].lstrip
  		end
  	            
      @user = User.where(osu_id: id ).first || User.create(osu_id: id, first_name: first_name, last_name: last_name)

      if  (! id )  
            
          errors.add :base, "Enter instructor OSU id"
          isValid = false
        
      elsif ( ! @user.save())   
      	
      	  errors.add :base, "User failed #{id}"
          isValid = false
      	          
      elsif ( isValid)
        
	       sheetEmails.each do |email|
	                  
	              findEmail = Gemail.find_for_authentication(email: email.downcase) || Gemail.create(email: email.downcase)
	              emails.push(findEmail)
	        end
			 
  			first_name = row["first_name"]
  			last_name = row["last_name"]
  		
  			if first_name == nil && last_name == nil
  				
  				name = row["Instructor Name"]
  				first_name = name.split(", ").last
  				last_name = name.split(", ").first
  
  			else
  				first_name = row["first_name"].rstrip
  				last_name = row["last_name"].lstrip
  			end
  		
  		
  	 		@user.update_attributes({
  	 	     osu_id: id,
  	 		 first_name: first_name,
  	       	 last_name: last_name,
  	       	 role: "Instructor",
  	       	 cc_instructor_tag: "#{last_name}, #{first_name[0]}.",
  	       	 consider: true
  
  	     	 })
                      
          
        emails.each do |email|
             email.update_attributes(user_id: @user.id)
        end
	     	 
	      ##################################### 	     
	     	 
	     	# current_enrollment = row["current_enrollment"]
	     	 name = row["Title"]
	    	term = row["Term"]
	    	honor= false
	    	ta_major = "ECE"
	    
	    	course_code = row["Subj and Course Num"]
	     	code = course_code.split(" ").first
	     	number = course_code.split(" ").last
	     	if number.end_with? "H"
	     		honor = true
	     	end
	     
	     	if code == "CS"
	     	 	ta_major = code
	     	 end

	     	crn = row["CRN"]
	     #	inst_name = row["Instructor Name"]
	     #	last_name = inst_name.split(", ").first
	     #	first_name = inst_name.split(", ").last

			@dep = Department.where({subject_code: code}).take
			if @dep == nil
	    		@dep = Department.create({subject_code: code})
	    	end
	    
	    	@course = Course.where({department: @dep, course_number: number}).take
	    	if @course == nil
	    		@course = Course.create({course_number: number,department: @dep, ta_major: ta_major, ignored: false })
	    	end
	    		
	 		@new_section = Section.where({crn: crn, term: term}).take
	 	if @new_section == nil
	 			@new_section = Section.create({
	       			crn: crn,
	       			course: @course,
	        		cc_instructor_tag: "#{last_name}, #{first_name[0]}." ,
	        		term:term,
	        		honor: honor,
	        		#current_enrollment: current_enrollment,
	        		#max_enrollment: current_enrollment,
	        		instructor_id: @user.id,
	        		section_name: name
	        		})
	 		
	    else
	    	 @new_section.update_attributes({
	    	 	honor: honor,
	        	section_name: name,
	       		instructor_id: @user.id,
	        	cc_instructor_tag: "#{last_name}, #{first_name[0]}."
	        	
	        	})
	    end 
	   	 @section_import = @new_section

	     ##################################### 	    
 
	     	 
	     	 
	     end
	    
	    
	    	
	   end
	  isValid 
	end

 
  def open_spreadsheet
    case File.extname(file.original_filename)
    when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
    else raise "Unknown file type use .xlxs: #{file.original_filename}"
    end
  end
 
 end