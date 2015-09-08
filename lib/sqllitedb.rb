require 'sqlite3'

class DBConnection
  def self.open(db_file_name)
    @db = SQLite3::Database.new(db_file_name)
    @db.results_as_hash = true
    @db.type_translation = true

    @db
  end

  def self.reset
    commands = [
      "rm '#{@db_file_name}'",
      "cat '#{@sql_file_name}' | sqlite3 '#{@db_file_name}'"
    ]

    commands.each { |command| `#{command}` }
    DBConnection.open(db_file_name)
  end

  def self.instance
    reset if @db.nil?

    @db
  end

  def self.execute(*args)
    puts args[0]

    instance.execute(*args)
  end

  def self.execute2(*args)
    puts args[0]

    instance.execute2(*args)
  end

  def self.last_insert_row_id
    instance.last_insert_row_id
  end

  private
  attr_reader :db_file_name, :sql_file_name
  def initialize(db_file_name)
    @db_file_name = db_file_name
    @sql_file_name = db_file_name.sub('.db', '.sql')
  end
end
