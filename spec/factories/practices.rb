# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :practice do
    date "2012-06-23 11:00:00"
    comment "at Waltham"
    season
  end
end
