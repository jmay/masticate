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
      if @field.is_a?(Fixnum) || @field =~ /^\d+/
        @index = @field.to_i
      else
        @index = row.index(@field) or raise "Unable to find column '#{@field}'"
      end
    elsif row
      ts = DateTime.strptime(row[@index], @format).to_time
      row[@index] = ts.to_i rescue nil
    end
    row
  end
end
