require 'spec_helper'

describe 'home' do
  it 'loads home page with nobody signed in' do
    visit root_path
    page.should have_content "Tennis team scheduling made easy"
  end
end

