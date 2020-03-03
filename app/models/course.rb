class Course < ActiveRecord::Base
  default_scope { order(department_id: :asc, course_number: :asc) }
  
  belongs_to :department
  has_many :sections

 
  def label
    "#{department.subject_code} #{course_number}"
  end
 	
end
