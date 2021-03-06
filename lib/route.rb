# frozen_string_literal: true

require_relative './route_helpers'

# Route class handles HTTP requests and directs to the corresponding controller action
class Route
  include RouteHelpers
  attr_reader :http_method, :pattern, :controller_class, :action_name

  def initialize(http_method, pattern, controller_class, action_name)
    @http_method = http_method
    @pattern = pattern
    @controller_class = controller_class
    @action_name = action_name
    add_route_helpers
  end

  def add_route_helpers
    case action_name
    when :create, :index
      name = class_name_plural
      add_path_method(name, "/#{name}")
    when :show, :update, :destroy
      name = class_name_singular
      add_path_method(name, "/#{class_name_plural}/:id")
    when :edit
      name = "edit_#{class_name_singular}"
      add_path_method(name, "/#{class_name_plural}/:id/edit")
    when :new
      name = "new_#{class_name_singular}"
      add_path_method(name, "/#{class_name_plural}/new")
    end
  end

  def class_name
    controller_class.to_s.underscore.gsub('_controller', '')
  end

  def class_name_singular
    class_name.singularize
  end

  def class_name_plural
    class_name.pluralize
  end

  def add_path_method(name, path)
    path_name = "#{name}_path"
    puts "#{path_name} #=> #{path}"

    define_singleton_method(path_name) do |*args|
      id = args.first.to_s
      path.gsub!(':id', id) if path.include?(':id') && !id.nil?
      path
    end
  end

  # checks if pattern matches path and method matches request method
  def matches?(req)
    pattern.match(req.path) && (http_method == req.request_method.downcase.to_sym)
  end

  # use pattern to pull out route params (save for later?)
  # instantiate controller and call controller action
  def run(req, res)
    match_data = pattern.match(req.path)
    route_params = Hash[match_data.names.zip(match_data.captures)]
    @controller_class
      .new(req, res, route_params)
      .invoke_action(action_name)
  end
end
