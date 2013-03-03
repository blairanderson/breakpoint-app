class TimeSelectInput < SimpleForm::Inputs::CollectionSelectInput
  private

  def collection
    generate_hours
  end

  def generate_hours
    time_options = []
    6.upto 11 do |hour|
      time_options << generate_minutes(hour, 'AM')
    end

    time_options << generate_minutes(12, 'PM')

    1.upto 11 do |hour|
      time_options << generate_minutes(hour, 'PM')
    end

    time_options.flatten
  end

  def generate_minutes(hour, am_or_pm)
    [0, 30].map do |minute|
      "%02d:%02d #{am_or_pm}" % [hour, minute]
    end
  end
end

