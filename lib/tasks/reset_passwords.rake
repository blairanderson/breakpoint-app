namespace :breakpointapp do  
  task :reset_passwords => :environment do
    if Rails.env.development?
      password = ::BCrypt::Password.create("password", cost: User.stretches)
      ActiveRecord::Base.connection.execute("UPDATE users SET encrypted_password = '#{password}'")
    end
  end
end

