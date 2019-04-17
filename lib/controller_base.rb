# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext'
require 'erb'

require_relative './session'
require_relative './flash'
require_relative './route'
require_relative './router'
require_relative './route_helpers'
require_relative './params'

# ControllerBase provides interface to handle http request, response, and rendering
class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res, route_params = {})
    @req, @res = req, res
    @already_built_response = false
    @params = Params.new(req, route_params)
  end

  def invoke_action(action_name)
    send(action_name)
    render(action_name) unless already_built_response?
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    raise 'Page Already Rendered?' if already_built_response?

    @res.header['location'] = url
    @res.status = 302
    @already_built_response = true
    session.store_session(@res)
    flash.store_flash(@res)
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    raise 'Page Already Rendered?' if already_built_response?

    @res.body = content
    @res.content_type = content_type
    @already_built_response = true
    session.store_session(@res)
    flash.store_flash(@res)
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    path = self.class.name.underscore
    file = File.dirname(__FILE__) +
           "/../app/views/#{path}/#{template_name}.html.erb"
    # if File.exist?(file)
    #   file = File.read(file)
    # else
    #   file += ".erb"
    # file =
    content = ERB.new(File.read(file)).result(binding)
    # end

    render_content(content, 'text/html')
  end

  def flash
    @flash ||= Flash.new(@req)
  end

  def session
    @session ||= Session.new(@req)
  end
end
