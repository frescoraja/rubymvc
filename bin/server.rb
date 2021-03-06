#! /usr/bin/env ruby
# frozen_string_literal: true

require 'webrick'

require_relative '../lib/router'
require_relative '../app/controllers/sketch_controller'
require_relative '../app/controllers/css_controller'
require_relative '../app/controllers/js_controller'

router = Router.new
router.draw do
  get Regexp.new('^/?(sketches)?$'), SketchController, :index
  get Regexp.new('^/?sketches/new$'), SketchController, :new
  get Regexp.new('^/?sketches/(?<id>\\d+)$'), SketchController, :show
  post Regexp.new('^/?sketches$'), SketchController, :create
  get Regexp.new('^/?stylesheet.css$'), CSSController, :style
  get Regexp.new('^/?newsketch.js$'), JSController, :send_js
  get Regexp.new('^/?serializejson.js$'), JSController, :send_js
end

PORT = ARGV[0] || 3000
server = WEBrick::HTTPServer.new(Port: PORT)
server.mount_proc('/') do |req, res|
  router.run(req, res)
end

trap('INT') { server.shutdown }
server.start
