# frozen_string_literal: true

require_relative './route'

# Router class is used to build routes
class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  def add_route(http_method, pattern, controller_class, action_name)
    routes << Route.new(http_method, pattern, controller_class, action_name)
  end

  %i[get post put delete].each do |http_method|
    define_method(http_method) do |pattern, controller_class, action_name|
      add_route(http_method, pattern, controller_class, action_name)
    end
  end

  def draw(&proc)
    instance_eval(&proc)
  end

  def match(req)
    @routes.find { |route| route.matches?(req) }
  end

  def run(req, res)
    route = match(req)
    if route.nil?
      res.status = 404
      res.body = "No Route found for #{req.request_method} at #{req.path}"
    else
      route.run(req, res)
    end
  end
end
