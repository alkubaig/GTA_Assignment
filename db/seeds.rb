require 'integer_linear_program'

class Enter
    
    def initialize
        puts "Seeding data..."
        seed_admins


    end
    
    def run
        puts "Fetching data..."
     
    end
    
    private
    
    
    def seed_admins
        
        @alkubaig = User.create! osu_id: 555555555, first_name: "Ghadeer", last_name: "Alkubaish", is_administrator: true, role: "Administrator"
     
        Gemail.create! email: "alkubaig@oregonstate.edu", user: @alkubaig
        
    end
    
  
	
end
ilp = Enter.new
ilp.run
