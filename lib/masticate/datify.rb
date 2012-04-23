# convert date columns to numerics
require "csv"

class Masticate::Datify < Masticate::Base
  def configure(opts)
    standard_options(opts)
    @field = opts[:field] or raise "missing field to datify"
    @format = opts[:format] or raise "strptime format required for parsing timestamps"
  end

  def datify(opts)
    execute(opts)
  end

  def crunch(row)
    if !@index
      @index = row.index(@field) or raise "Unable to find column '#{@field}'"
    elsif row
      ts = DateTime.strptime(row[@index], @format).to_time
      row[@index] = ts.to_i rescue nil
    end
    row
  end
end
