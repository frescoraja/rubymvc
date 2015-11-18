require_relative '../../lib/controller_base'
require_relative '../models/sketch'
require 'cloudinary'

class SketchController < ControllerBase
  def index
    @sketches = Sketch.all
  end

  def create
    image = Cloudinary::Uploader.upload(sketch_params['image'],
      { cloud_name: ENV[cloud_name], name: ENV[name], api_key: ENV[api_key], api_secret: ENV[api_secret] })
    new_params = sketch_params.merge({ 'image' => image['url'], created_at: Time.now })
    @sketch = Sketch.new(new_params)
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
