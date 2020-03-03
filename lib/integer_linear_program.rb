require "rulp"

Rulp::log_level = Logger::UNKNOWN
Rulp::print_solver_outputs = false

class IntegerLinearProgram
  attr_accessor :students, :sections, :assignments_fte, :assignments_is_fixed
  attr_accessor :allow_double_ass
  attr_accessor :fte_per_section, :students_per_ta,  :round_cut_off,  :lower_fte_bound, :fte_per_student
  attr_accessor :problem

  def initialize(students, sections, assignments_fte = {}, assignments_is_fixed = {}, previous_assignments = {}, allow_double_ass = false, students_per_ta = 30,  round_cut_off = 15, lower_fte_bound = 0.25, fte_per_section = 0.25)
    self.students             = students
    self.sections             = sections
    self.assignments_fte      = assignments_fte
    self.assignments_is_fixed = assignments_is_fixed
    self.fte_per_section      = fte_per_section
    
    round        = Setting.where(var: "round_cut_off" ).take 
    self.round_cut_off        = round ? round.value : 15
    st_ta = Setting.where(var: "students_per_ta" ).take
    self.students_per_ta      = st_ta ? st_ta.value : 30
    
    self.fte_per_student      = fte_per_section / self.students_per_ta
    self.lower_fte_bound      = lower_fte_bound
    self.allow_double_ass = allow_double_ass
   
	puts "initialize ilp"
    	self.problem = Rulp::Max(objective)
    	contraint

  end

  def solve
  	
	puts "solve ilp"
	self.problem.save("problems/problem.lp")
  	self.problem.cbc(parallel: true, node_limit: 10_000, gap: 0.05, open_definition: true)
 end

  def results
    results = {}
    self.students.each do |student|
      self.sections.each do |section|
      	results[:"#{student.id}_#{section.id}"] = (VAR_f(student.id, section.id)).value
       # results[:"#{student.id}_#{section.id}"] = (VAR_f(student.id, section.id)).value.round(2)#.to_s[0..3].to_f
      end
    end
    self.assignments_is_fixed.each do |key, value|
        student_id, section_id = key.split("_")
      	results[:"#{student_id}_#{section_id}"] = self.assignments_fte[:"#{student_id}_#{section_id}"].to_f
     
	end
    results
  end

  def inspect
    self.problem.inspect
  end

  def print_results
    self.students.each do |student|
      puts "#{student.full_name} (#{student.fte})"
      self.sections.each do |section|
        if VAR_f(student.id, section.id).value > 0
          puts "\t #{section.course.label} #{section.location} (#{VAR_f(student.id, section.id).value})"
        end
      end
      puts
    end
  end

private

  def objective

    variables = []
    

    instructor_student_preferences = {}
 
  self.sections.each do |section|
       section.student_preferences.each do |preference|
			instructor_student_preferences[:"#{preference.student.id}_#{preference.section.id}"] = preference
		end 
    end
   
  	
   self.students.each do |student|
   	
   	      experiences = student.experiences.index_by { |experience| :"#{experience.skill_id}" }

   	     self.sections.each do |section|
     		
     		unless self.assignments_is_fixed[:"#{student.id}_#{section.id}"] == "true"
     			
	      		section_preferences =
	       	 	student.section_preferences.index_by { |preference| :"#{student.id}_#{preference.section.id}" }
	      	
	      	
	       		student_score = section_preferences[:"#{student.id}_#{section.id}"].try(:value_raw)
	       		student_score ||= 1
	
	        	instructor_score = instructor_student_preferences[:"#{student.id}_#{section.id}"].try(:value_raw)
	       		instructor_score ||= 1
	        
	        	unless instructor_score == 1 
	       			instructor_score *= 60
				end
			
				unless student_score == 1 
	       			student_score *= 30
				end
				
				exper_score = 1
				section.requirements.each do |requirement|
          			exp = experiences[:"#{requirement.skill_id}"]
         			if exp != nil &&  exp[:value] != 0 && exp[:value] >= requirement[:value]
  						 exper_score += 1
         			 end
       			end
       		
       		  	student_score *= exper_score

		
			 	 variables <<  instructor_score * student_score  * VAR_f(student.id, section.id)
			end
	      end
    end

	if variables == []
		variables << 1 * VAR_f(self.students[0].id, self.sections[0].id)
		
	end
   	 variables.sum
  	
  end

  def contraint
    self.sections.each do |section|
     
        variables = []
 		max = section.adjusted_enrollment(self.students_per_ta, self.round_cut_off ) * self.fte_per_student
 		self.students.each do |student|
 							
 			if self.assignments_is_fixed[:"#{student.id}_#{section.id}"] == "true"
 				max -= self.assignments_fte[:"#{student.id}_#{section.id}"].to_f	
 			else
 				variables <<  VAR_f(student.id, section.id)
 				
 				major_constraint(student, section)
 			  	lower_bounds_constraint(student, section)
 			end			     		
 		end
 		
 		max = max < -1 ? 0 : max
 	   	constraint = (variables.sum <= max) if variables.sum
     	self.problem[ constraint ]

    end
  	fte_contraint
  end
 
  def fte_contraint
  	 
  	 self.students.each do |student|
 	 	fte = student.fte
 		 variables = []
 		 self.sections.each do |section|
 	 	
 	 		if self.assignments_is_fixed[:"#{student.id}_#{section.id}"] == "true"
 				fte -= self.assignments_fte[:"#{student.id}_#{section.id}"].to_f	
 			else
 				variables <<  VAR_f(student.id, section.id)
 			end
 		 end
	     constraint = (variables.sum <= fte) if variables.sum
    	 self.problem[ constraint ]
    end
end

 
 def lower_bounds_constraint(student, section)
 		
	if self.allow_double_ass == "1"
		self.problem[ VAR_f(student.id, section.id) - self.lower_fte_bound * VAR_b(student.id, section.id, "bool") >= 0 ]
	else
	  	if section.adjusted_enrollment(self.students_per_ta, self.round_cut_off ) >= (self.students_per_ta * 2) && student.fte == (0.5)
	  		self.problem[ VAR_f(student.id, section.id) - (0.5) * VAR_b(student.id, section.id, "bool") >= 0 ]		
	   else
	     	self.problem[ VAR_f(student.id, section.id) - self.lower_fte_bound * VAR_b(student.id, section.id, "bool") >= 0 ]
	   end
	end
	self.problem[ VAR_f(student.id, section.id) - 10 * VAR_b(student.id, section.id, "bool") <= 0 ]
end

 def major_constraint(student, section)
	unless section.course.ta_major == "ECE/CS"
		unless (section.course.ta_major == "ECE" &&  student.major != "CS" &&  student.major != "ECE")
		 if student.major != section.course.ta_major 
	       	 self.problem[ VAR_f(student.id, section.id) <= 0 ] # Hardcode to NO
		  	 self.problem[ VAR_f(student.id, section.id) >= 0 ] # Hardcode to NO
	     end
	    end
	 end
end

end

 
