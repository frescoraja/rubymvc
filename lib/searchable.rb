# frozen_string_literal: true

require_relative './sql_object'

# Searchable module provides an interface to query the DB for model instances
module Searchable
  def find(id)
    result = DBConnection.exec(<<-SQL)
    SELECT
      *
    FROM
      #{table_name}
    WHERE
      id = #{id.to_i}
    SQL

    parse_all(result).first
  end

  def where(params)
    where_line = params.keys.map.with_index { |key, i| "#{key} = $#{i + 1}" }.join(' AND ')

    results = DBConnection.exec(<<-SQL, params.values)
    SELECT
      *
    FROM
      #{table_name}
    WHERE
      #{where_line}
    SQL

    parse_all(results)
  end
end

# SQLObject class represents a RubyMVC SQL model
class SQLObject
  extend Searchable
end
