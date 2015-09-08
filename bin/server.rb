#! /usr/bin/env ruby

require 'webrick'
require_relative '../lib/router'
require_relative '../app/controllers/sketch_controller'
require_relative '../app/controllers/css_controller'

router = Router.new
router.draw do
  get Regexp.new("^/$"), SketchController, :index
  get Regexp.new("^/sketch/new$"), SketchController, :new
  post Regexp.new("^/sketch$"), SketchController, :create
  destroy Regexp.new("^/sketch/")
  get Regexp.new("^/stylesheet.css"), CSSController, :show
end

PORT = ARGV[0] || 3000
VERS = WEBrick::HTTPVersion.new('1.1')
CONFIG = {
  Port: PORT,
  HTTPVersion: VERS,
  DocumentRoot: "/",
  ServerName: "ServAir",
  ServerAlias: ["Servidora", "ServiDoor"]
}
server = WEBrick::HTTPServer.new(CONFIG)
server.mount_proc('/') do |req, res|
  router.run(req, res)
end

trap('INT') { server.shutdown }
server.start
