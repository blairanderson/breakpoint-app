class Team < ActiveRecord::Base
  include DateParser

  has_many :practices,    -> { order(:date => :asc) }, :dependent => :destroy
  has_many :matches,      -> { order(:date => :asc) }, :dependent => :destroy
  has_many :invites,      :dependent => :destroy
  has_many :team_members, :dependent => :destroy
  has_many :users,        :through   => :team_members

  validates :name,            presence: true, uniqueness: true
  validates :email,           presence: true, uniqueness: true, format: { with: /\A[a-z0-9\-_]+\z/, message: "can only contain lowercase letters, numbers, - and _" }
  validates :singles_matches, presence: true
  validates :doubles_matches, presence: true

  def self.newest
    order('date desc')
  end

  def email_address
    "#{email}@mail.breakpointapp.com"
  end

  def upcoming_practices
    practices.where('date > ?', Time.zone.now).order('date asc')
  end

  def upcoming_matches
    matches.where('date > ?', Time.zone.now).order('date asc')
  end

  def previous_matches
    matches.where('date < ?', Time.zone.now).order('date asc')
  end

  def active_users
    users.where("team_members.state != 'inactive'")
  end

  def team_emails
    active_users.where('team_members.receive_email = true').pluck(:email)
  end

  def not_accepted_user_ids
    invites.not_accepted.pluck(:user_id)
  end

  def team_member_for(user_id)
    team_members.where(user_id: user_id).first
  end

  def accepted_team_members
    team_members.includes(:user).reject { |u| not_accepted_user_ids.include?(u.user_id) }
  end

  def not_accepted_team_members
    team_members.includes(:user).select { |u| not_accepted_user_ids.include?(u.user_id) }
  end

  def users_from_emails(emails)
    # remove existing team_members
    emails = emails - users.pluck(:email)
    existing_users = User.where(email: emails)
    new_emails = emails - existing_users.collect(&:email)
    new_users = new_emails.map do |email|
      name = name_from_email(email)
      User.new(first_name: name[:first_name],
               last_name:  name[:last_name],
               email:      email,
               password:   SecureRandom.uuid)
    end
    {
      new_users: new_users,
      existing_users: existing_users
    }
  end

  def name_from_email(email)
    email_name = email.split('@').first
    email_name = email_name.scan(/[a-zA-Z]+/).map(&:capitalize).join(' ')
    {
      first_name: email_name.split(' ').first,
      last_name: email_name.split(' ')[1..-1].join(' ')
    }
  end
end

# TODO
# Club/Facility
# Team Name
# Team Type
#  Adult
#  Mixed
#  Senior
#  Senior 65
#  Senior 60
#  Fifty Mixed
#  Combo
#  Juniors
#  HighSchool
#  College
#  Other
# Level
#  2.5
#  3.0
#  3.5
#  4.0
#  4.5
#  5.0
#  5.5
#  6.0
#  6.5
#  7.0
#  7.5
#  8.0
#  8.5
#  9.0
#  9.5
#  Open
#  Juniors
#  HighSchool
#  College
#  Other
# Singles Matches 0-9
# Doubels Matches 0-9
# Alternates 0-9 (???)

# == Schema Information
#
# Table name: teams
#
#  created_at      :datetime         not null
#  date            :datetime         not null
#  doubles_matches :integer          not null
#  id              :integer          not null, primary key
#  name            :string(255)      default(""), not null
#  singles_matches :integer          not null
#  updated_at      :datetime         not null
#

