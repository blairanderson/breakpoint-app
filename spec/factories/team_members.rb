FactoryGirl.define do
  factory :team_member do
    team
    user
    role 'captain'
  end
end
