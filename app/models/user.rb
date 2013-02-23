class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :trackable,
    :validatable

  has_many :team_members,         :dependent => :restrict
  has_many :teams,                :through   => :team_members
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
    :phone_number
  
  def name
    if first_name.present? && last_name.present?
      "#{first_name} #{last_name}"
    elsif first_name.empty? && last_name.present?
      "#{last_name}"
    elsif first_name.present? && last_name.empty?
      "#{first_name}"
    else
      email
    end
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
#  sign_in_count          :integer          default(0)
#  updated_at             :datetime         not null
#

