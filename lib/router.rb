require_relative './route'

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern, controller_class, action_name|
      add_route(pattern, http_method, controller_class, action_name)
    end
  end

  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(pattern, method, controller_class, action_name)
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
