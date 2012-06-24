class User < ActiveRecord::Base
  ROLES = %w[admin captain team_member]
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :trackable,
    :validatable

  has_many :players, :dependent => :restrict
  has_many :seasons, :through => :players
  has_many :practice_sessions, :dependent => :restrict
  has_many :practices, :through => :practice_sessions
  
  attr_accessible :email,
    :password,
    :password_confirmation,
    :remember_me,
    :first_name,
    :last_name,
    :phone_number,
    :role
  
  validates_presence_of :first_name, :last_name

  def name
    "#{first_name} #{last_name}"
  end

  def admin?
    role == "admin"
  end

  def captain?
    role == "captain"
  end

  def team_member?
    role == "team_member"
  end
end
