FactoryGirl.define do
  factory :gemail do
    email "MyString"
    user_id 1
  end
  factory :emaily do
    email "MyString"
    user_id 1
  end
  factory :email do
    email "MyString"
    user_id 1
  end

  factory :courses_white_list do
    department "MyString"
    courseNumber 1
  end
  factory :keep_user do
    first_name "MyString"
    last_name "MyString"
    role "MyString"
    email "MyString"
    fte ""
    cc_instructor_tag "MyString"
  end

  factory :user do
    first_name "John"
    last_name "Doe"
    sequence(:email) { |n| "user#{n}@oregonstate.edu" }
    password "keyboardcat"

    factory :administrator, class: User do
      is_administrator true
    end

    factory :instructor, class: User do
    end

    factory :student, class: User do
      fte 0.25
    end
  end

  factory :section_preference do
  end
  factory :student_preference do
  end

  factory :department do
    name "Computer Science"
    subject_code "CS"
  end

  factory :course do
    sequence(:name)          { |n| "Course #{n}" }
    sequence(:course_number) { |n| n }
    association :department
  end

  factory :section do
    current_enrollment 30
    association :course
    association :instructor
  end

  factory :skill do
    name "C++"
    type 0
  end

end
