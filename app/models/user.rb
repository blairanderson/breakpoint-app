class User < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name, :phone_number
  
  validates_presence_of :first_name, :last_name, :email

  def name
    "#{first_name} #{last_name}"
  end
end
