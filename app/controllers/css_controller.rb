# frozen_string_literal: true

require_relative '../../lib/controller_base'

# CSSController handles serving CSS files from
class CSSController < ControllerBase
  def style
    filename = File.dirname(__FILE__) + "/../stylesheets/#{req.path}"
    res.body = File.read(filename)
    res.content_type = 'text/css'
    @already_built_response = true
  end
end
