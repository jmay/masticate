# extract subset of columns from CSV
require "csv"

class Masticate::MaxRows < Masticate::Base
  def configure(opts)
    standard_options(opts)

    @groupby = opts[:by] or raise "missing field to group by"
    @maxon = opts[:max] or raise "missing field to max on"
  end

  def maxrows(opts)
    configure(opts)

    @output_count = 0
    headers = nil
    accum = {}
    with_input do |input|
      while line = get
        row = CSV.parse_line(line, csv_options)
        if !headers
          headers = row
          index_by = headers.index(@groupby) or raise "Unable to find column '#{@groupby}'"
          index_max = headers.index(@maxon) or raise "Unable to find column '#{@maxon}'"
          emit(line)
        else
          key = row[index_by]
          if !accum[key]
            accum[key] = row
          else
            oldscore = accum[key][index_max]
            newscore = row[index_max]
            if newscore > oldscore
              accum[key] = row
            end
          end
        end
      end
    end

    accum.each do |k,row|
      emit(row.to_csv)
    end

    @output.close if opts[:output]

    {
      :input_count => @input_count,
      :output_count => @output_count
    }
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
        emit(row.to_csv)
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
    end
  end
end
