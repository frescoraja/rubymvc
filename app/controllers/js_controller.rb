require_relative '../../lib/controller_base'

class JSController < ControllerBase
  def script
    filename = File.dirname(__FILE__) + "/../js/newsketch.js"
    res.body = File.read(filename)
    res.content_type = "text/javascript"
    @already_built_response = true
  end
end
