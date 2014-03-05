captain = User.create!(email: Faker::Internet.email,
                       first_name: Faker::Name.first_name,
                       last_name: Faker::Name.last_name,
                       phone_number: Faker::PhoneNumber.phone_number,
                       password: SecureRandom.uuid)

members = 0.upto(8).map do
  User.create!(email: Faker::Internet.email,
               first_name: Faker::Name.first_name,
               last_name: Faker::Name.last_name,
               phone_number: Faker::PhoneNumber.phone_number,
               password: SecureRandom.uuid)
end

team = Team.new(name: Faker::Company.name,
                email: Faker::Internet.domain_word,
                singles_matches: 2,
                doubles_matches: 3,
                date: 1.week.from_now)
team.team_members.build(user: captain, role: TeamMember::ROLES.first, state: "active")
members.each { |m| team.team_members.build(user: m, role: TeamMember::ROLES.last, state: "active") }
team.save!

ActsAsTenant.with_tenant(team) do
  0.upto(8) do |i|
    p_address = "#{Faker::Address.street_address}\n#{Faker::Address.city}, #{Faker::Address.state_abbr} #{Faker::Address.zip}"
    m_address = "#{Faker::Address.street_address}\n#{Faker::Address.city}, #{Faker::Address.state_abbr} #{Faker::Address.zip}"
    #p_date_string = (i + 2).send(:weeks).from_now
    Practice.create!(team: team, date: (i + 2).send(:weeks).from_now, location: p_address, comment: Faker::Lorem.sentence(10))
    Match.create!(team: team, date: (i + 3).send(:weeks).from_now, location: m_address, comment: Faker::Lorem.sentence(10))
  end

  team.users.each do |user|
    Match.all.each do |match|
      next if [1,2,3,4].sample == 3
      match.match_availabilities.create!(team: team, user: user, available: [true, false].sample)
    end

    Practice.all.each do |practice|
      next if [1,2,3,4].sample == 3
      practice.practice_sessions.create!(team: team, user: user, available: [true, false].sample)
    end
  end
end

