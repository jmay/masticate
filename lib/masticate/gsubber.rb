# extract subset of columns from CSV
require "csv"

class Masticate::Gsubber < Masticate::Base
  def configure(opts)
    standard_options(opts)

    @field = opts[:field] or raise "missing field to gsub"
    @from = Regexp.new(opts[:from]) or raise "Invalid regex '#{opts[:from]}' for conversion"
    @to = opts[:to] or raise "missing 'to' string for gsub"
  end

  def set_headers(row)
    @headers = row
    @index = @headers.index(@field) or raise "Unable to find column '#{@field}' in headers"
  end

  def gsub(opts)
    configure(opts)
    @output_count = 0
    headers = nil
    with_input do |input|
      while line = get
        row = CSV.parse_line(line, csv_options)
        if !headers
          headers = row
          index = headers.index(@field) or raise "Unable to find column '#{@field}' in headers"
          emit(line)
        else
          oldval = row[index]
          newval = oldval.gsub(@from, @to)
          row[index] = newval
          emit(row.to_csv)
        end
      end
    end
    @output.close if opts[:output]

    {
      :input_count => input_count,
      :output_count => @output_count
    }
  end

  def crunch(row)
    # puts "GSUB CRUNCH #{row}"
    if !@headers
      set_headers(row)
    else
      row[@index] = row[@index].gsub(@from, @to)
    end
    # puts "GSUB RESULT IS #{row}"
    row
  end
end
