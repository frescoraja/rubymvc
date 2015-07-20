require 'uri'

class Params
  # use your initialize to merge params from
  # 1. query string
  # 2. post body
  # 3. route params
  #
  # You haven't done routing yet; but assume route params will be
  # passed in as a hash to `Params.new` as below:
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

  class AttributeNotFoundError < ArgumentError; end;

  private
  # this should return deeply nested hash
  # argument format
  # user[address][street]=main&user[address][zip]=89436
  # should return
  # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
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

  # this should return an array
  # user[address][street] should return ['user', 'address', 'street']
  def parse_key(key)
    key.split(/\]\[|\[|\]/)
  end
end
