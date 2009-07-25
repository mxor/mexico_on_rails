ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  if html_tag =~ /<(input|label|textarea|select)/
    error_class = 'field-error'
    nodes = Hpricot(html_tag)
    nodes.each_child do |node|
      node[:class] = node.classes.push(error_class).join(' ') unless !node.elem? ||
        node[:type] == 'hidden' || node.classes.include?(error_class)
    end
    nodes.to_html
  else
    html_tag
  end
end