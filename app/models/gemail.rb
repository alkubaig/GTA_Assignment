class Gemail < ActiveRecord::Base
  belongs_to :user
  validates :email, email: true, presence: true, uniqueness: true
  validates_format_of :email,:with => /\A[^@\s]+@oregonstate.edu+\z/,  :message => "Email address must end with @oregonstate.edu"
  
  
  devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :trackable,:omniauthable,
           :omniauth_providers => [:google_oauth2]



  
  def uid 
  
    self.user_id  
  end
  
end
