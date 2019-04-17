# frozen_string_literal: true

require 'uri'

# Params provides interface to handle request parameters as a Hash
class Params
  def initialize(req, route_params = {})
    @params = {}
    @params.merge!(route_params)
    @params.merge!(parse_www_encoded_form(req.body)) if req.body
    @params.merge!(parse_www_encoded_form(req.query_string)) if req.query_string
  end

  def [](key)
    key = key.to_s
    @params[key]
  end

  def to_s
    @params.to_s
  end

  # class AttributeNotFoundError < ArgumentError; end;

  private

  def parse_www_encoded_form(www_encoded_form)
    params = {}
    keys_values = URI.decode_www_form(www_encoded_form)

    keys_values.each do |key, value|
      nest = params
      key_list = parse_key(key)
      key_list.each_with_index do |el, idx|
        if key_list.count == idx + 1
          nest[el] = value
        else
          nest[el] ||= {}
          nest = nest[el]
        end
      end
    end

    params
  end

  def parse_key(key)
    key.split(/\]\[|\[|\]/)
  end
end
