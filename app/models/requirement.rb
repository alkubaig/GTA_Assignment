class Requirement < ActiveRecord::Base
  enum value: {
    :"Qualified"          => 2,
    :"Slightly qualified" => 1,
    :"Unqualified"        => 0,
  }

  validates_uniqueness_of :skill_id, scope: [:section_id]

  validates_presence_of :skill_id
  validates_presence_of :section_id
  validates_presence_of :instructor_id
  validates_presence_of :value

  belongs_to :skill
  belongs_to :section
  belongs_to :instructor
end
