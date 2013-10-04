namespace :breakpointapp do  
  task :reset_passwords => :environment do
    if Rails.env.development?
      User.all.each { |u| u.reset_password!("password", "password") }
    end
  end
end

