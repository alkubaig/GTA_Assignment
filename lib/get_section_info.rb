require "mysection"

class GetSectionInfo
	
	
ENDPOINT = "http://catalog.oregonstate.edu"
SECTIONS_XPATH = "//table[@id='ctl00_ContentPlaceHolder1_SOCListUC1_gvOfferings']//tr[position() > 1]"
TITLE_XPATH = "//form/h3"


 attr_accessor :sections
 attr_accessor :results
 
  def initialize(sections )
    self.sections= sections
    self.results = []
  end

  def solve
  	
  	results = []
 	sections.each do |section|
  				
	  	subject_code = section.course.department.subject_code
	  	course_number = section.course.course_number
	  	course_name = section.course.name
	    honor =  ""
	    if section.honor == true
	    	honor = "H"
	    	end
	  	
		html = fetch_sections(subject_code,course_number,honor )
	    parse_sections(html,subject_code,course_number,course_name)

	end
	
  end

 def res
    results
  end


private



def fetch_sections(subject_code,course_number,honor )
		
    open("#{ENDPOINT}/CourseDetail.aspx?subjectcode=#{subject_code}&coursenumber=#{course_number}#{honor}").read
end

def parse_sections(html,subject_code,course_number,course_name )

	
    document = Oga.parse_html(html)
    document.xpath(SECTIONS_XPATH).map { |row|
      
     # this_res = [] 
      
      results.push( Mysection.new(
            subject_code,
            course_number,
            course_name,
            parse_term(row),
            parse_crn(row),
            parse_section(row),
            parse_instructor(row),
            section_location(parse_campus(row)),
            parse_type(row),
            parse_status(row),
            parse_capacity(row),
            parse_current(row)
          ))
 
   }
end

def fetch_column(document, selector)
    document.xpath(selector)&.text&.delete("\r\n")&.strip
end

def parse_term(row)
    fetch_column(row, "td[position() = 1]")
end

def parse_crn(row)
    fetch_column(row, "td[position() = 2]")
end

def parse_section(row)
    fetch_column(row, "td[position() = 3]")
end

def parse_instructor(row)
    fetch_column(row, "td[position() = 6]")
end

def parse_campus(row)
    fetch_column(row, "td[position() = 9]")
end

def parse_type(row)
    fetch_column(row, "td[position() = 11]")
end

def parse_status(row)
    fetch_column(row, "td[position() = 12]")
end

def parse_capacity(row)
    fetch_column(row, "td[position() = 13]")&.to_i
end

def parse_current(row)
    fetch_column(row, "td[position() = 14]")&.to_i
end

 def section_location(campus)
      (campus == "Corv") ? "On campus" : "Ecampus"
 end

end