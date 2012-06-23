class Practice < ActiveRecord::Base
  belongs_to :season

  attr_accessible :comment, :chronic_date

  validates_presence_of :date
  
  def chronic_date
    I18n.l self.date, :format => :long unless self.date.nil?
  end

  def chronic_date= value
    self.date = Chronic.parse(value)
  rescue ArgumentError
    @date_invalid = true
  end

  def validate
    errors.add(:date, 'is invalid') if @date_invalid
  end
end
