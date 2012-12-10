# extract subset of columns from CSV
require "csv"

class Masticate::Plucker < Masticate::Base
  def configure(opts)
    standard_options(opts)

    @fields = opts[:fields] or raise "missing fields to pluck"
    if @fields.is_a?(String)
      @fields = @fields.split(/,\s*/)
    end
  end

  def pluck(opts)
    execute(opts)
  end

  def crunch(row)
    if !@headers
      @headers = row
      @indexes = @fields.map do |f|
        case f
        when Fixnum, /^\d+/
          f = f.to_i
          if f > row.count
            raise "Cannot pluck column #{f}, there are only #{row.count} fields"
          else
            f-1
          end
        else
          row.index(f) or raise "Unable to find column '#{f}'"
        end
      end
      @indexes.map {|i| row[i]}
    elsif row
      # output is just the selected columns
      @indexes.map {|i| row[i]}
    end
  end
end
