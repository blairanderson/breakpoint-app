FactoryGirl.define do
  factory :user do
    first_name   'John'
    last_name    'Doe'
    email        'john.doe@example.com'
    phone_number '555-555-5555'
  end

  factory :season do
    name '2012 Summer'
  end
end