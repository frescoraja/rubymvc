require_relative "../../lib/pgdb"
require_relative "../../lib/sql_object"

class Sketch < SQLObject
  self.make_cols_attr_accessors
end
