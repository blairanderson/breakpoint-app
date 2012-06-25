require 'spec_helper'

describe Practice do
  it 'accepts a string for date' do
    tomorrow_at_7pm = Time.new Time.now.year, Time.now.month, Time.now.day + 1, 19
    practice = Practice.new :date_string => 'tomorrow at 7pm', :comment => 'at Waltham'
    practice.date.should eq(tomorrow_at_7pm)
  end
end

# == Schema Information
#
# Table name: practices
#
#  comment    :text
#  created_at :datetime         not null
#  date       :datetime         not null
#  id         :integer          not null, primary key
#  season_id  :integer          default(0), not null
#  updated_at :datetime         not null
#

