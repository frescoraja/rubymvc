require 'pg'

class Database < PG::Connection
  def initialize
    super(
      host: 'ec2-54-163-228-0.compute-1.amazonaws.com',
      port: 5432,
      dbname: 'dcvdhmareuuktn',
      user: 'fnklupsrqslrko',
      password: 'yyoi_ncUFHJapa9joARkwkWYyy'
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
    @db
  end

  def self.exec(*args)
    puts args[0]

    instance.exec(*args)
  end

  def initialize
    @db = Database.new
  end
end
