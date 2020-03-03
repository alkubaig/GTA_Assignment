class Section < ActiveRecord::Base
  self.inheritance_column = nil

  enum location: {
    :"On campus" => 0,
    :"Ecampus"   => 1
  }

  scope :with_current_term , -> { where(term: Setting.current_term) }


  belongs_to :instructor, class_name: "User"#,
   # foreign_key: "cc_instructor_tag", primary_key: "cc_instructor_tag"
  belongs_to :course
  
  has_many :student_preferences
  has_many :section_preferences
  has_many :requirements



 def location_short
 	location == "On campus" ? "" : "E"
 end

  def adjusted_enrollment(students_per_ta, round_cut_off )

  	adjust = merge_curr_num
  	mod = merge_curr_num % students_per_ta

  	if mod >= round_cut_off
  		diff = students_per_ta - mod
  		adjust = merge_curr_num + diff
  	else
 		adjust = merge_curr_num - mod
 	end
  	

  	if num_ta > 0
  		adjust = students_per_ta * num_ta
  	end
  	adjust
  end

 def is_merge
 	to_merge = false
 	cross_listed = Setting.where(var: "cross_listed").take
 	if cross_listed != nil 
 	   	cross_listed.value.each do |s|
 		s.each do |ss|
 			if "#{self.course.id}/" == ss
  				to_merge = true
 				break;
 			end
 		end
 	end
end
 	to_merge
 end


 def is_show
 	to_show = false
  cross_listed = Setting.where(var: "cross_listed").take
 	if cross_listed != nil 
 	   	cross_listed.value.each do |s|
 		prev = []
 		s.each do |ss|
 			if "#{self.course.id}/" == ss
 				has_main = is_main(prev)
 				if has_main == false
 					to_show = true
 					break;
 				end
 			end
 			prev.append(ss)
 		end
 	end
end
 	self.is_merge ? self.update_attributes({show: to_show}) : self.update_attributes({show: true})
 	to_show
 end


def sections_meged
	merged = []
 	cross_listed = Setting.where(var: "cross_listed").take
 	if cross_listed != nil 
 	   	cross_listed.value.each do |s|
	 		prev = []
	 		s.each do |ss|
	 			if "#{self.course.id}/" == ss
	 				has_main = is_main(prev)
	
	 				if has_main == false
	 					merged = list(s)
	 					break;
	 				end
	 			end
	 			prev.append(ss)
	 		end
	 	end
 	end
 	merged
end

 	def merge_dep_
	 	dep = self.course.department.subject_code
		other_dep = ""
	
		if is_show && is_merge
	
			sections_meged.select{ |s|
	
				if s.course.department != self.course.department
	
					if other_dep.empty?
						other_dep = s.course.department.subject_code
						dep = "#{dep} / #{s.course.department.subject_code}"
						self.course.update_attributes({ta_major: "ECE/CS"})
					end
				end
			}
		end
		self.update_attributes({merge_dep: dep})
		dep
   	end
   
   	def merge_num_
		num = "#{self.course.course_number}"
	    other_num = ""
		if is_show && is_merge
	
			sections_meged.select{ |s|
	
				if s.course.course_number != self.course.course_number
	
					if other_num.empty?
						other_num = s.course.department.subject_code
						num = "#{num} / #{s.course.course_number}"
					end
	
				end
			}
		end
		self.update_attributes({merge_num: num})
		num
   	end

def merge_label
	 "#{merge_dep} #{merge_num}"
end

def merge_curr_num_
	num = self.current_enrollment
	if is_show && is_merge

		sections_meged.select{ |s|

			unless  s.current_enrollment == nil
				num += s.current_enrollment
			end
		}
	end
	self.update_attributes({merge_curr_num: num})
	num
end

def merge_max_num_
	num = self.max_enrollment
	if is_show && is_merge

		sections_meged.select{ |s|

			unless  s.current_enrollment == nil
				num += s.max_enrollment
			end
		}
	end
	self.update_attributes({merge_max_num: num})
	num
end

def list(s)
	mylist = []
	num = 0
	s.each do |add|
	 	if add != "#{self.course.id}/"
	 		course_sec = Course.find(add)
	 		course_sec.sections.with_current_term.each do |sec|
	 			if self.location == sec.location && sec.cc_instructor_tag == self.cc_instructor_tag
	 				mylist.push(sec)
 				end
 			end
 		end
 	end
	mylist
end


def is_main(prev)
	has_main = false
 	prev.each do |main|
 		course_sec = Course.find(main)
 		course_sec.sections.with_current_term.each do |sec|
 			if self.location == sec.location && sec.cc_instructor_tag == self.cc_instructor_tag
 				has_main = true
 			end
 		end
 	end
 	has_main
end


def update_sections
		is_show
		merge_dep_
		merge_num_
		merge_curr_num_
		merge_max_num_
end

end
