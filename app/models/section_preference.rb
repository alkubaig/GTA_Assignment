class SectionPreference < ActiveRecord::Base
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

  validates_uniqueness_of :student_id, scope: [:section_id]

  validates_presence_of :student_id
  validates_presence_of :section_id
  validates_presence_of :value
  validate :validate_values


  belongs_to :section
  belongs_to :student , class_name: "User"

    def validate_values
    errors.add(:value, "You can not disfavor more than 6 sections") if SectionPreference.where(student_id: student_id, value: 0).with_current_term.count > 6
  end

end
