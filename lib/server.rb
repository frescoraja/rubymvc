#! /usr/bin/env ruby

require 'webrick'
require_relative '../lib/router'

router = Router.new
router.draw do

end

PORT = ARGV[0] || 4000
server = WEBrick::HTTPServer.new(Port: PORT)
server.mount_proc('/') do |req, res|
  router.run(req, res)
end

trap('INT') { server.shutdown }
server.start
