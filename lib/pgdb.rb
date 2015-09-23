require 'pg'

class Database < PG::Connection
  def initialize
    super(
      host: 'ec2-54-204-25-54.compute-1.amazonaws.com',
      port: 5432,
      dbname: 'dj0s7i0dpac7r',
      user: 'fowhogviesmazr',
      password: '4nzViH2f20fagvWbl1phfmrTxK'
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
