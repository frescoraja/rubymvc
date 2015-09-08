class SketchController < ControllerBase
  def index
    @sketches = Sketch.all
  end

  def create
    @sketch = Sketch.new(sketch_params)
  end

  private
  def sketch_params
    { sketch: params[]}
  end
end
