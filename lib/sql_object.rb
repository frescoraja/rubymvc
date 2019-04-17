# frozen_string_literal: true

require_relative './pgdb'
require_relative './searchable'
require_relative './associatable'
require 'active_support/inflector'

# SQLObject is the model representation of a DB row item
class SQLObject
  attr_writer :name, :table_name

  def self.columns
    return @columns if @columns

    result =
      DBConnection.exec(<<-SQL)
        SELECT
          *
        FROM
          #{table_name}
        LIMIT
          0
      SQL

    @columns = result.fields.map(&:to_sym)
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
      define_method(column_name.to_s) do
        attributes[column_name]
      end
    end
  end

  def self.make_cols_attr_accessors
    columns.each do |sym|
      define_method(sym) do
        attributes[sym]
      end

      define_method((sym.to_s + '=').to_sym) do |value|
        attributes[sym] = value
      end
    end
  end

  def self.table_name
    name = self.name.downcase
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
    results.map { |attributes| new(attributes) }
  end

  def initialize(params = {})
    params.each do |key, value|
      raise "unknown attribute '#{key}'" unless self.class.columns.include?(key.to_sym)

      send("#{key}=", value)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    attributes.values
  end

  def non_empty_attributes
    attributes.select{|k, v| v.strip != ""}
  end

  def non_empty_values
    non_empty_attributes.values
  end

  def non_empty_column_names
    non_empty_attributes.keys
  end

  def column_names
    @column_names ||= (attributes.keys - [:id])
  end

  def insert
    col_names = non_empty_column_names.map(&:to_s).join(',')
    values = non_empty_column_names.map.with_index { |_, i| "$#{i + 1}" }.join(',')
    result = DBConnection.exec(<<-SQL, non_empty_values)
    INSERT INTO
      #{self.class.table_name} (#{col_names})
    VALUES
      (#{values})
    RETURNING
      id
    SQL
    self.id = result[0]['id'].to_i
  end

  def update
    col_names = non_empty_column_names.map { |col_name| "#{col_name} = ?" }.join(', ')
    DBConnection.exec(<<-SQL, non_empty_values)
    UPDATE
      #{table_name}
    SET
      #{col_names}
    WHERE
      id = #{id}
    SQL
  end

  def save
    id.nil? ? insert : update
  end
end
