require_relative '../../lib/controller_base'
require_relative '../models/sketch'

class SketchController < ControllerBase
  def index
    @sketches = Sketch.all
  end

  def create
    @sketch = Sketch.new(sketch_params)
  end

  def new
  end

  private
  def sketch_params
    {
      'title' => params['sketch']['title'],
      'author' => params['sketch']['author'],
      'url' => params['sketch']['url']
    }
  end
end
