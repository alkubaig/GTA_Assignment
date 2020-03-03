class StudentPreference < ActiveRecord::Base
  enum value: {
    :"Disfavor" => 0,
    :"Neutral" => 1,
    :"Slightly Favor" => 2,
    :"Favor" => 3,
    :"Highly Favor" => 4,
  }

  def value_raw
    read_attribute('value')
  end

  scope :with_current_term, -> {
    joins(:section).where(sections: { term: Setting.current_term })
  }
 
  validates_uniqueness_of :student_id, scope: [:section_id, :instructor_id]

  validates_presence_of :instructor_id
  validates_presence_of :section_id
  validates_presence_of :student_id
  validates_presence_of :value

  belongs_to :instructor, class_name: "User"
  belongs_to :student, class_name: "User"
  belongs_to :section
end
