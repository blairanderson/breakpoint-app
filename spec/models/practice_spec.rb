require 'spec_helper'

describe Practice do
  it 'accepts a string for date' do
    team = create(:team)
    practice = Practice.create(:team => team, :date_string => '6/13/2014', :time_string => '05:30 PM', :comment => 'at Waltham')
    practice.date.should eq(Time.zone.parse('2014-06-13 17:30'))
  end

  it 'returns team emails' do
    user = create(:user)
    user2 = create(:user2)
    team = create(:team, :users => [user, user2])
    practice = create(:practice, :team => team)

    practice.team_emails.should eq ['john.doe@example.com', 'dave.kroondyk@example.com']
  end

  it 'returns the practice session for a specified user id' do
    user = create(:user)
    team = create(:team, :users => [user])
    practice = create(:practice, :team => team)
    practice_session = create(:practice_session, :practice => practice, :user => user)

    practice.practice_session_for_user(user.id).should eq practice_session
  end
end

# == Schema Information
#
# Table name: practices
#
#  id             :integer          not null, primary key
#  date           :datetime         not null
#  comment        :text
#  team_id      :integer          default(0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  notified_state :string(255)
#

