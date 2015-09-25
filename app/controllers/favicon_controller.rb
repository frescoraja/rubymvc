require_relative '../../lib/controller_base'

class Favicon < ControllerBase
  def favicon
    filename = File.dirname(__FILE__) + "/favicon.ico"
    res.body = File.read(filename)
    res.content_type = "image/x-icon"
  end
end
