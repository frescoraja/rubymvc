# frozen_string_literal: true

require_relative '../../lib/controller_base'

# JSController serves js content
class JSController < ControllerBase
  def send_js
    filename = File.dirname(__FILE__) + "/../js/#{req.path}"
    res.body = File.read(filename)
    res.content_type = 'text/javascript'
    @already_built_response = true
  end
end
