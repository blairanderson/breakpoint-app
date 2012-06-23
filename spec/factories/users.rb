FactoryGirl.define do
  factory :user do
    first_name            'John'
    last_name             'Doe'
    email                 'john.doe@example.com'
    phone_number          '555-555-5555'
    password              'testing'
    password_confirmation 'testing'

    factory :user2 do
      first_name 'Dave'
      last_name  'Kroondyk'
      email      'dave.kroondyk@example.com'
    end
  end
end