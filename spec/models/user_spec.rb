require 'spec_helper'

describe User do
  it 'returns name when first and last exist' do
    user = build(:user, :first_name => 'DK', :last_name => 'Row')
    user.name.should eq 'DK Row'
  end

  it 'returns first name when last is empty' do
    user = build(:user, :first_name => 'DK', :last_name => '')
    user.name.should eq 'DK'
  end

  it 'returns last name when first is empty' do
    user = build(:user, :first_name => '', :last_name => 'Row')
    user.name.should eq 'Row'
  end

  it 'returns email when first and last are empty' do
    user = build(:user, :first_name => '', :last_name => '', :email => 'dkrow@example.com')
    user.name.should eq 'dkrow@example.com'
  end

  it 'nils work too' do
    user = build(:user, :first_name => '', :last_name => nil, :email => 'dkrow@example.com')
    user.name.should eq 'dkrow@example.com'
  end
end

