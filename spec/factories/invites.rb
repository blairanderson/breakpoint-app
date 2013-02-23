# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invite do
    user nil
    team nil
    invited_by 1
    accepted_at "2013-02-18 17:11:11"
  end
end
