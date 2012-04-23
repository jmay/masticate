# extract subset of columns from CSV
require "csv"

class Masticate::Plucker < Masticate::Base
  def configure(opts)
    standard_options(opts)

    @fields = opts[:fields] or raise "missing fields to pluck"
  end

  def pluck(opts)
    configure(opts)

    @output_count = 0
    headers = nil
    with_input do |input|
      while line = get
        row = CSV.parse_line(line, csv_options)
        emit crunch(row)
      end
    end
    @output.close if opts[:output]

    {
      :input_count => input_count,
      :output_count => @output_count
    }
  end

  def crunch(row)
    if !@headers
      @headers = row
      @indexes = @fields.map do |f|
        case f
        when String
          row.index(f) or raise "Unable to find column '#{f}'"
        when Fixnum
          if f > row.count
            raise "Cannot pluck column #{f}, there are only #{row.count} fields"
          else
            f-1
          end
        else
          raise "Invalid field descriptor '#{f}'"
        end
      end
      @indexes.map {|i| row[i]}
    elsif row
      # output is just the selected columns
      @indexes.map {|i| row[i]}
    end
  end
end
