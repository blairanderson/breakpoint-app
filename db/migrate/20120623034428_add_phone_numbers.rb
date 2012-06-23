class AddPhoneNumbers < ActiveRecord::Migration
  def up
    User.find_by_last_name('Bacanurschi').update_attribute(:phone_number, '8576361486')
    #User.find_by_last_name('Beloborodo​v').update_attribute(:phone_number, '(857) 4981907')
    User.find_by_last_name('Bhandari').update_attribute(:phone_number, '8572726586')
    User.find_by_last_name('Fridella').update_attribute(:phone_number, '617-429-1686')
    User.find_by_last_name('Ghosh').update_attribute(:phone_number, '5088162715')
    User.find_by_last_name('Jain').update_attribute(:phone_number, '2154109570')
    User.find_by_last_name('Kim').update_attribute(:phone_number, '404-797-1935')
    User.find_by_last_name('Notarnicola').update_attribute(:phone_number, '857-284-2688')
    User.find_by_last_name('Sadalgi').update_attribute(:phone_number, '9174889233')
    User.find_by_last_name('Susser').update_attribute(:phone_number, '617-285-1964')
  end

  def down
  end
end
