module ApplicationHelper
  def flash_name_for_bootstrap(name)
    case name
    when :alert
      { :class => 'warning', :icon => 'warning-sign' }
    when :notice
      { :class => 'success', :icon => 'ok-sign' }
    when :info
      { :class => 'info', :icon => 'info-sign' }
    when :error
      { :class => 'error', :icon => 'exclamation-sign' }
    else
      { :class => name, :icon => 'info-sign' }
    end
  end

  def active_tab(kontroller_name, &block)
    class_name = controller_name.include?(kontroller_name) ? 'active' : nil
    content_tag :li, :class => class_name do
      capture(&block)
    end
  end
end

