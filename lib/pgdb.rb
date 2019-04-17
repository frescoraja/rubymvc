# frozen_string_literal: true

require 'pg'
require 'uri'

# Database provides the interface to execute queries in a DB
class Database < PG::Connection
  def initialize
    db_url = ENV['DATABASE_URL'] || "postgresql://#{ENV['USER']}@localhost:5432/rubymvc"
    params = URI.parse(db_url)
    super(
      host: params.host,
      port: params.port,
      dbname: params.path[1..-1],
      user: params.user,
      password: params.password
      )
  end

  def self.exec(*args)
    exec(*args)
  end

  def self.exec_params(*args)
    exec_params(*args)
  end
end

# DBConnection is the base class for Database
class DBConnection
  def self.instance
    @db ||= Database.new
  end

  def self.exec(*args)
    puts args[0]

    instance.exec(*args)
  end
end
