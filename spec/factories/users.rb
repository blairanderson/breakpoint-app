FactoryGirl.define do
  factory :user do
    first_name   'John'
    last_name    'Doe'
    email        'john.doe@example.com'
    phone_number '555-555-5555'

    factory :user2 do
      first_name 'Dave'
      last_name  'Kroondyk'
    end
  end
end