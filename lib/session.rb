# frozen_string_literal: true

require 'json'
require 'webrick'

# Session class stores session/cookie data
class Session
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    found_cookie = req.cookies.find { |c| c.name == '_ruby_mvc_app' }
    @data = found_cookie.nil? ? {} : JSON.parse(found_cookie.value)
  end

  def [](key)
    @data[key]
  end

  def []=(key, val)
    @data[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    res.cookies << WEBrick::Cookie.new('_ruby_mvc_app', @data.to_json)
  end
end
