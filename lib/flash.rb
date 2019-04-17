# frozen_string_literal:true

# HashWithIndifferentAccess extends Hash interface to allow lookup by string name or symbol
class HashWithIndifferentAccess < Hash
  def [](key)
    super(key.to_s)
  end

  def []=(key, val)
    super(key.to_s, val)
  end
end

# Flash class stores flash data in HashWithIndifferentAccess
class Flash
  def initialize(req)
    cookie = req.cookies.find { |c| c.name == '_ruby_mvc_app_flash' }

    @flash_now = HashWithIndifferentAccess.new
    @data = HashWithIndifferentAccess.new

    return unless cookie

    JSON.parse(cookie.value).each do |k, v|
      @flash_now[k] = v
    end
  end

  def now
    @flash_now
  end

  def [](key)
    now[key] || @data[key]
  end

  def []=(key, val)
    now[key] = val
    @data[key] = val
  end

  def store_flash(res)
    cookie = WEBrick::Cookie.new(
      '_ruby_mvc_app_flash',
      @data.to_json
    )
    cookie.path = '/'
    res.cookies << cookie
  end
end
