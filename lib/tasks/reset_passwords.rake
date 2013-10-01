namespace :breakpointapp do  
  task :reset_passwords => :environment do
    if Rails.env.development?
      User.all.each do |u|
        u.update_attributes(password: "password", password_confirmation: "password")
      end
    end
  end
end

