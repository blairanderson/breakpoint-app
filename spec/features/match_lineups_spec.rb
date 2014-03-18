require 'spec_helper'

describe 'match_lineups' do
  before :each do
    login_captain
    ActsAsTenant.current_tenant = create(:team)
    @match = create(:match, team: ActsAsTenant.current_tenant)
    @match.team.team_members.create(:user => @captain, :role => 'captain', :state => 'active')
    @match.team.team_members.create(:user => create(:user2), :role => 'member', :state => 'active')
    ActsAsTenant.current_tenant = nil
    visit team_matches_path(@match.team)
  end

  it 'sets the match lineup' do
    click_button 'I can play'
    click_link   'Set the lineup'
    first("option[value='#{@captain.id}']").select_option
    click_button 'Save match lineup'

    page.should have_selector '.alert.alert-success', :text => 'Match updated'
    @match.match_lineups.first.match_players.where(:user_id => @captain.id).count.should eq(1)

    click_link 'Set the lineup'
    first("option[value='']").select_option
    click_button 'Save match lineup'

    page.should have_selector '.alert.alert-success', :text => 'Match updated'
    @match.match_lineups.first.match_players.where(:user_id => @captain.id).count.should eq(0)
  end

  it 'sets the match lineup' do
    click_button 'I can play'
    click_link   'Set the lineup'
    first("option[value='#{@captain.id}']").select_option
    click_button 'Save match lineup'
    click_link 'Preview and send lineup email'
    fill_in 'comments', :with => 'testing extra comments'
    click_button 'Email team'

    last_email.body.should match /testing extra comments/
    last_email.attachments.should have(1).attachment
    last_email.attachments.first.content_type.should eq 'text/calendar; charset=UTF-8'
    page.should have_selector '.alert.alert-success', :text => 'Lineup email sent to team'
  end
end

