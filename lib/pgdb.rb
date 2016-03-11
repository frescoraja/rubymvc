require 'pg'
require 'uri'

class Database < PG::Connection
  def initialize
    params = URI.parse(ENV['DATABASE_URL'])
    super(
      host: params.host,
      port: params.port,
      dbname: params.path[1..-1],
      user: params.user,
      password: params.password
      )
  end

  def self.exec(*args)
    self.exec(*args)
  end

  def self.exec_params(*args)
    self.exec_params(*args)
  end
end

class DBConnection
  def self.instance
    @db ||= Database.new
  end

  def self.exec(*args)
    puts args[0]

    instance.exec(*args)
  end
end
