class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :players, :dependent => :restrict
  has_many :seasons, :through => :players
  
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :email, :first_name, :last_name, :phone_number
  
  validates_presence_of :first_name, :last_name

  def name
    "#{first_name} #{last_name}"
  end
end
