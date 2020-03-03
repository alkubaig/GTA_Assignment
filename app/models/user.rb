class User < ActiveRecord::Base
  	before_validation :set_password, on: :create
	before_save :set_cc_instructor_tag, on: :create
	

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,:omniauthable,
         :omniauth_providers => [:google_oauth2]
         
   

  has_many :student_preferences, foreign_key: "instructor_id"
  has_many :section_preferences, foreign_key: "student_id"
  has_many :experiences, ->{ joins(:skill) }, foreign_key: "student_id"
  has_many :sections, foreign_key: "instructor_id" #, primary_key: "cc_instructor_tag"
  
  has_many :gemails, inverse_of: :user
  
  validates :osu_id, presence: true, uniqueness: true, numericality: { only_integer: true }


 # after_commit :save_default_email, on: :create

  #belongs_to :default_email, class_name: "Gemail"
 # validates :default_email, presence: true
  #default_scope { includes :default_email }

   default_scope { order(major: :asc,is_wait_list: :asc, last_name: :asc) }
   
 #  accepts_nested_attributes_for :gemails, reject_if: :all_blank, allow_destroy: true
   accepts_nested_attributes_for :gemails, allow_destroy: true

   
   scope :student, -> { where({role: 'Student',consider: true}) }
   scope :cs_students, -> { student.where({major: 'CS'}) }
   scope :ece_students, -> { student.where.not({major: 'CS'}) }
   
  # scope :ece_students_first , -> {order( major: :desc, is_wait_list: :asc, last_name: :asc) }
   #scope :cs_students_first , -> {order( major: :asc, is_wait_list: :asc,last_name: :asc) }
   #scope :normal , -> {order(is_wait_list: :asc, major: :asc, last_name: :asc) }


 def emails 
 	
 	arr = []
 	gemails.each do |e|
 		arr.push(e.email)
 		end
 	
 	arr
 	
 	
 end
#   def email
#     default_email.email 
#   end
#  
#   def self.having_email email
#     User
#       .includes(:gemails)
#       .joins(emails: {
#         email:  email
#       })
#       .first
#   end

#   def self.find_first_by_auth_conditions warden_conditions
#     conditions = warden_conditions.dup
#     if email = conditions.delete(:email)
#       having_email email
#     else
#       super(warden_conditions)
#     end
#   end
 

  def self.instructors
       	
    where(cc_instructor_tag: Section.joins(:course).select(:cc_instructor_tag)
        .with_current_term
       	.where('courses.ignored = ?', false)
       	.where(role: "Instructor")
       	)
       	
  end
 
  def self.gtas_approved
 	 where({role: 'Student', is_wait_list: false})
  end


  def self.gtas
  	where('fte > 0')
  end

  def self.from_omniauth(access_token)
    data = access_token.info
    
    login_email = Gemail.where(email: data["email"]).first
      
     if login_email
     	  user =  User.find(login_email.uid)
	end    
    user
  end
 
 def notRegistred
 	role == nil || role.empty?
 end

  def full_name
    "#{first_name} #{last_name}"
  end

  def is_student
  	 self.role == "Student"
   # self.sections.with_current_term.length == 0
  end

  def is_instructor

  	 self.role == "Instructor"
  end

  private
 

#   def save_default_email
#     if default_email.user.blank?
#       default_email.user = self
#     elsif default_email.user != self
#       raise Exceptions::EmailConflict
#     end
#     default_email.save!
#   end
  

    def set_password
      self.password = Devise.friendly_token[0,20]
    end
   
   private

    def set_cc_instructor_tag
      	self.cc_instructor_tag = "#{self.last_name}, #{self.first_name[0]}." if self.role != "Student"
    end
end
