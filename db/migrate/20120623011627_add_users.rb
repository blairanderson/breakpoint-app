class AddUsers < ActiveRecord::Migration
  def up
    User.create :last_name => 'Bacanurschi', :first_name => 'Boris',     :email => 'vika_boris@hotmail.com'
    User.create :last_name => 'Bazydlo',     :first_name => 'Jaime',     :email => 'jaimebazydlo@gmail.com'
    #User.create :last_name => 'Beloborodo​v', :first_name => 'Mark',      :email => 'belobor@gmail.com'
    User.create :last_name => 'Bhandari',    :first_name => 'Sudershan', :email => 'bhandari.sudershan@gmail.com'
    User.create :last_name => 'Fridella',    :first_name => 'Steve',     :email => 'sfridella@comcast.net'
    User.create :last_name => 'Ghosh',       :first_name => 'Anees',     :email => 'aneesghosh@hotmail.com'
    User.create :last_name => 'Jain',        :first_name => 'Nitish',    :email => 'nitish17@gmail.com'
    User.create :last_name => 'Kim',         :first_name => 'Philseok',  :email => 'pkim@seas.harvard.edu'
    User.create :last_name => 'Kroondyk',    :first_name => 'Dave',      :email => 'davekaro@gmail.com'
    User.create :last_name => 'Notarnicola', :first_name => 'Stephen',   :email => 'st.notar@gmail.com'
    User.create :last_name => 'Reese',       :first_name => 'Brendan',   :email => 'reese.vt@gmail.com'
    User.create :last_name => 'Sadalgi',     :first_name => 'Shrenik',   :email => 'shrenik.sadalgi@gmail.com'
    User.create :last_name => 'Susser',      :first_name => 'Mark',      :email => 'mark.susser@gmail.com'
  end

  def down
    User.delete_all
  end
end
