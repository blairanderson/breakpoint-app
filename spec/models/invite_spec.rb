require 'spec_helper'

describe Invite do
  it 'allows name to be set manually' do
    invite = build(:invite, :email => 'davekaro@gmail.com', :name => 'David Kroondyk')
    invite.name.should eq 'David Kroondyk'
  end

  it 'parses name from email' do
    invite = build(:invite, :email => 'davekaro@gmail.com')
    invite.name.should eq 'Davekaro'
  end

  it 'parses name from email and separates name by non-letter' do
    invite = build(:invite, :email => 'dave_karo@gmail.com')
    invite.name.should eq 'Dave Karo'
  end

  it 'parses name from email and strips digits' do
    invite = build(:invite, :email => '123dave_karo123@gmail.com')
    invite.name.should eq 'Dave Karo'
  end

  it 'parses first name from email' do
    invite = build(:invite, :email => 'dave_karo@gmail.com')
    invite.first_name.should eq 'Dave'
  end

  it 'parses last name from email' do
    invite = build(:invite, :email => 'dave_karo@gmail.com')
    invite.last_name.should eq 'Karo'
  end

  it 'parses first and last name from email with multiple separators' do
    invite = build(:invite, :email => 'dave_karo_the_great@gmail.com')
    invite.first_name.should eq 'Dave'
    invite.last_name.should eq 'Karo The Great'
  end
end

