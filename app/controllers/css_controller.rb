require_relative '../../lib/controller_base'

class CSSController < ControllerBase
  def style
    filename = File.dirname(__FILE__) + "/../stylesheets/stylesheet.css"
    res.body = File.read(filename)
    res.content_type = "text/css"
    @already_built_response = true
  end
end
