class TimeSelectInput < SimpleForm::Inputs::StringInput
  def input
    @input_type = :string
    template.content_tag :div, :class => "input-append bootstrap-timepicker" do
      span = template.content_tag :span, :class => "add-on" do
        template.content_tag :i, "", :class => "icon-time"
      end

      super + span
    end
  end

  def input_html_classes
    super.push("timepicker")
  end
end

