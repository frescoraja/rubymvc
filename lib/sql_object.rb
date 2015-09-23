require_relative './pgdb'
require_relative './searchable'
require_relative './associatable'
require 'active_support/inflector'
DBConnection
class SQLObject
  def self.columns
    return @columns if @columns
    column_names =
    DBConnection.exec(<<-SQL)
    SELECT
      *
    FROM
      #{table_name}
    LIMIT
      0
    SQL

    @columns = column_names.fields.map(&:to_sym)
  end

  def self.count
    DBConnection.exec(<<-SQL)
    SELECT
      COUNT(*)
    FROM
      #{table_name}
    SQL
  end

  def self.finalize!
    columns.each do |column_name|
      define_method("#{column_name}=") do |value|
        attributes[column_name] = value
      end
      define_method("#{column_name}") do
        attributes[column_name]
      end
    end
  end

  def self.make_cols_attr_accessors
    self.columns.each do |sym|
      define_method(sym) do
        attributes[sym]
      end

      define_method((sym.to_s + '=').to_sym) do |value|
        attributes[sym] = value
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    name = self.name.downcase.pluralize
    @table_name ||= name
  end

  def self.all
    results = DBConnection.exec(<<-SQL)
    SELECT
      *
    FROM
      #{table_name}
    SQL

    parse_all(results)
  end

  def self.parse_all(results)
    results.map { |attributes| self.new(attributes) }
  end

  def self.find(id)
    result = DBConnection.exec(<<-SQL, id)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        id = ?
    SQL

    parse_all(result).first
  end

  def self.id

  end
  
  def initialize(params = {})
    params.each do |key, value|
      raise "unknown attribute '#{key}'" unless self.class.columns.include?(key.to_sym)
      self.send("#{key}=", value)
    end

    update
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    #self.class.columns.map { |attr_name| self.send(attr_name) }
    attributes.values
  end

  def insert
    col_names = self.class.columns.join(",")
    question_marks = ["?"] * (col_names.count(",") + 1)
    self.id = DBConnection.exec(<<-SQL, *attribute_values)
    INSERT INTO
      #{self.class.table_name} (#{col_names})
    VALUES
      (#{question_marks.join(',')})
    RETURNING
      id
    SQL

  end

  def update
    col_names = self.class.columns.map { |col_name| "#{col_name} = ?" }.join(", ")
    DBConnection.exec(<<-SQL, *attribute_values, self.id)
    UPDATE
      #{self.class.table_name}
    SET
      #{col_names}
    WHERE
      id = ?
    SQL
  end

  def save
    self.id.nil? ? insert : update
  end
end
