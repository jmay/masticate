# extract subset of columns from CSV
require "csv"

class Masticate::MaxRows < Masticate::Base
  def configure(opts)
    standard_options(opts)

    @groupby = opts[:by] or raise "missing field to group by"
    @maxon = opts[:max] or raise "missing field to max on"
  end

  def maxrows(opts)
    execute(opts)
  end

  def crunch(row)
    if !@headers
      @headers = row
      @index_by = row.index(@groupby) or raise "Unable to find column '#{@groupby}'"
      @index_max = row.index(@maxon) or raise "Unable to find column '#{@maxon}'"
      @accum = {}
      row
    elsif row.nil?
      # output the accumulated results
      @accum.each do |k,row|
        yield row
      end
    else
      key = row[@index_by]
      if !@accum[key]
        @accum[key] = row
      else
        oldscore = @accum[key][@index_max]
        newscore = row[@index_max]
        if newscore > oldscore
          @accum[key] = row
        end
      end
      nil
    end
  end
end
