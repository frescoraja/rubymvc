require_relative "../../lib/pgdb"
require_relative "../../lib/sql_object"

class Sketch < SQLObject
  self.finalize!
end
