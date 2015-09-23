require_relative '../../lib/controller_base'
require_relative '../models/sketch'

class SketchController < ControllerBase
  def index
    @sketches = Sketch.all
  end

  def create
    params = sketch_params
    
    path = "/../public/uploads/img_#{ Time.now.to_i }.png"
    File.open(path, "wb") do |f|
      f.write(params[:image].read)
    end
    sketch_params[:image] = path
    debugger
    @sketch = Sketch.new(sketch_params)
    @sketch.save
    redirect_to("/")
  end

  def new

  end

  private
  def sketch_params
    {
      'title' => params['sketch']['title'],
      'author' => params['sketch']['author'],
      'image' => params['sketch']['image']
    }
  end
end
