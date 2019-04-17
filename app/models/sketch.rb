# frozen_string_literal: true

require_relative '../../lib/pgdb'
require_relative '../../lib/sql_object'

# Sketch model represents the sketch table in DB
class Sketch < SQLObject
  finalize!
end
