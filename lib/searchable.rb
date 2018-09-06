require_relative './sql_object'

module Searchable
  def find(id)
    result = DBConnection.exec(<<-SQL)
    SELECT
      *
    FROM
      #{self.table_name}
    WHERE
      id = #{id.to_i}
    SQL

    parse_all(result).first
  end

  def where(params)
    where_line = params.keys.map.with_index{|key, i| "#{key} = $#{i+1}"}.join(" AND ")

    results = DBConnection.exec(<<-SQL, params.values)
    SELECT
      *
    FROM
      #{self.table_name}
    WHERE
      #{where_line}
    SQL

    parse_all(results)
  end
end

class SQLObject
  extend Searchable
end
