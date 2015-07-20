require_relative './route'

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  # simply adds a new route to the list of routes
  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(pattern, method, controller_class, action_name)
  end

  # evaluate the proc in the context of the instance
  # for syntactic sugar :)
  def draw(&proc)
    instance_eval(&proc)
  end

  # make each of these methods that
  # when called add route
  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern, controller_class, action_name|
      add_route(pattern, http_method, controller_class, action_name)
    end

  # should return the route that matches this request
  def match(req)
    @routes.find { |route| route.matches?(req) }
  end

  # either throw 404 or call run on a matched route
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
