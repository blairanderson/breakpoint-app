require 'spec_helper'

describe MatchPolicy do
  subject { MatchPolicy }

  permissions :set_availabilities? do
    it 'grants access if user is on team' do
      user = create(:user)
      team = create(:team, :users => [user])
      match = create(:match, :team => team)
      should permit(user, match)
    end

    it 'denies access if user is not on team' do
      user = create(:user)
      team = create(:team)
      match = create(:match, :team => team)
      should_not permit(user, match)
    end
  end
end

