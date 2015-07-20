module RouteHelpers
  def link_to(title, path)
    "<a href='#{path}'>#{title}</a>"
  end

  def button_to(title, path, options = {})
    form = "<form action='#{path}' method='post'>"
    if options[:method]
      form += "<input type='hidden' name='_method' value='#{options[:method]}'>"
    end
    form += "<input type='submit' value='#{title}'>"
    form += "</form>"
    
    form
  end
end
