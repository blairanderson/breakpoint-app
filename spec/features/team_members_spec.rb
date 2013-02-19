require 'spec_helper'

describe 'team members' do
  before :each do
    login_captain
    @team_member = create(:team_member)
    @user2 = create(:user2)
    visit season_team_members_path(@team_member.season)
  end

  it 'shows team members in a season' do
    page.should have_content 'John Doe'
  end
end

