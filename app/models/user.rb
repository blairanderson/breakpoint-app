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

  has_many :invitations,          :dependent => :restrict_with_exception, :class_name => 'Invite'
  has_many :team_members,         :dependent => :restrict_with_exception
  has_many :teams,                :through   => :team_members
  has_many :practice_sessions,    :dependent => :restrict_with_exception
  has_many :practices,            :through   => :practice_sessions
  has_many :match_availabilities, :dependent => :restrict_with_exception
  has_many :matches,              :through   => :match_availabilities

  validate :first_name_or_last_name_present
  validates_inclusion_of :time_zone, in: ActiveSupport::TimeZone.zones_map(&:name)

  def first_name_or_last_name_present
    if first_name.blank? && last_name.blank?
      errors.add(:base, 'Please fill in first name or last name, preferably both.')
    end
  end
  
  def name
    if first_name.present? && last_name.present?
      "#{first_name} #{last_name}"
    elsif first_name.blank? && last_name.present?
      "#{last_name}"
    elsif first_name.present? && last_name.blank?
      "#{first_name}"
    end
  end

  def captain_of?(team)
    member = team_members.where(:team_id => team.id).first
    return false if member.nil?
    member.role == 'captain' || member.role == 'co-captain'
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  first_name             :string(255)      default("")
#  last_name              :string(255)      default("")
#  phone_number           :string(255)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default("")
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  time_zone              :string(255)      default("Eastern Time (US & Canada)")
#

