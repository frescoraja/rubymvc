require_relative '../../lib/controller_base'

class JSController < ControllerBase
  def new_sketch_script
    filename = File.dirname(__FILE__) + "/../js/newsketch.js"
    res.body = File.read(filename)
    res.content_type = "text/javascript"
    @already_built_response = true
  end

  def serializejson_script
    filename = File.dirname(__FILE__) + "/../js/serializejson.js"
    res.body = File.read(filename)
    res.content_type = "text/javascript"
    @already_built_response = true
  end
end
