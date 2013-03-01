module ChronicParser
  def self.included(klass)
    klass.extend(ClassMethods)
    klass.setup_accessible
  end

  module ClassMethods
    def setup_accessible
      validates_presence_of :date_string
    end
  end

  def date_string
    I18n.l self.date, :format => :long unless self.date.nil?
  end

  def date_string= value
    self.date = Chronic.parse(value)
  rescue ArgumentError
    @date_invalid = true
  end

  def validate
    errors.add(:date_string, 'is invalid') if @date_invalid
  end
end

