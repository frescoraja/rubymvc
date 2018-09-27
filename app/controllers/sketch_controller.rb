require_relative '../../lib/controller_base'
require_relative '../models/sketch'
require 'cloudinary'

class SketchController < ControllerBase
  def index
    @sketches = Sketch.all.sort do |x, y|
      DateTime.parse(x.created_at) <=> DateTime.parse(y.created_at)
    end
  end

  def create
    auth = {
      :cloud_name => ENV['cloud_name'],
      :api_key    => ENV['api_key'],
      :api_secret => ENV['api_secret']
    }
    image = Cloudinary::Uploader.upload(sketch_params['image'], auth)
    @sketch = Sketch.new(sketch_params.merge({ 'image' => image['url'] }))
    @sketch.save

    redirect_to("/")
  end

  def new
  end

  def show
    @sketch = Sketch.find(params[:id])
  end

  private
  def sketch_params
    params['sketch']
  end
end

