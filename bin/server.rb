#! /usr/bin/env ruby

require 'byebug'
require 'webrick'
require 'method_source'

require_relative '../lib/router'
require_relative '../app/controllers/sketch_controller'
require_relative '../app/controllers/css_controller'
require_relative '../app/controllers/js_controller'
require_relative '../app/controllers/favicon_controller'

router = Router.new
router.draw do
  get Regexp.new("^[/]?$"), SketchController, :index
  get Regexp.new("^/sketches[/]?$"), SketchController, :index
  get Regexp.new("^/sketches/new[/]?$"), SketchController, :new
  post Regexp.new("^/sketches[/]?$"), SketchController, :create
  get Regexp.new("^/stylesheet.css$"), CSSController, :style
  get Regexp.new("^/newsketch.js$"), JSController, :script
  get Regexp.new("^[/]?favicon.ico$"), Favicon, :icon
end

PORT = ARGV[0] || 3000
server = WEBrick::HTTPServer.new(Port: PORT)
server.mount_proc("/") do |req, res|
  router.run(req, res)
end

trap('INT') { server.shutdown }
server.start
