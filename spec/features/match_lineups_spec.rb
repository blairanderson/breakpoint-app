require 'spec_helper'

describe 'match_lineups' do
  before :each do
    login_captain
    @match = create(:match)
    @old_match = create(:match_in_past)
    visit season_path(@match.season)
  end

  it 'sets the match lineup' do
    click_button 'I can play'
    click_link   'Set the lineup'
    select 'captain captain', :from => '#1 Singles'
    click_button 'Save match lineup'

    page.should have_selector '.alert.alert-success', :text => 'Match updated'
    @match.match_lineups.where(:user_id => @captain.id).count.should eq(1)

    click_link 'Set the lineup'
    select '', :from => '#1 Singles'
    click_button 'Save match lineup'

    page.should have_selector '.alert.alert-success', :text => 'Match updated'
    @match.match_lineups.where(:user_id => @captain.id).count.should eq(0)
  end
end

