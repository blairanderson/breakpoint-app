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

  has_many :players,              :dependent => :restrict
  has_many :seasons,              :through   => :players
  has_many :practice_sessions,    :dependent => :restrict
  has_many :practices,            :through   => :practice_sessions
  has_many :match_availabilities, :dependent => :restrict
  has_many :matches,              :through   => :match_availabilities

  attr_accessible :email,
    :password,
    :password_confirmation,
    :remember_me,
    :first_name,
    :last_name,
    :phone_number,
    :role
  
  validates_presence_of :first_name, :last_name, :role

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

# == Schema Information
#
# Table name: users
#
#  created_at             :datetime         not null
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string(255)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  first_name             :string(255)      default(""), not null
#  id                     :integer          not null, primary key
#  last_name              :string(255)      default(""), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string(255)
#  phone_number           :string(255)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  role                   :string(255)      default("team_member"), not null
#  sign_in_count          :integer          default(0)
#  updated_at             :datetime         not null
#

