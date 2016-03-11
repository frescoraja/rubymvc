require 'pg'
require 'uri'

class Database < PG::Connection
  def initialize
    uri = URI.parse(ENV['DATABASE_URL'])
    db_params = parse_db_params(uri)
    super(db_params)
  end

  def self.parse_db_params(params)
    {
      host: params.hostname,
      dbname: params.path[1..-1],
      port: params.port,
      user: params.user,
      password: params.password
    }
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
