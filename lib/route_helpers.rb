# frozen_string_literal: true

# RouteHelpers can be used in ERB templates to create common routing components
module RouteHelpers
  def link_to(title, path)
    "<a href='#{path}'>#{title}</a>"
  end

  def button_to(title, path, options = {})
    form = "<form action='#{path}' method='post'>"
    option[:method] && form += "<input type='hidden' name='_method' value='#{options[:method]}'>"
    form += "<input type='submit' value='#{title}'>"
    form += '</form>'

    form
  end
end
