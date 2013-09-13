class TimeSelectInput < SimpleForm::Inputs::StringInput
  def input
    template.content_tag(:div, super, :class => "input-append bootstap-timepicker")
  end
end

