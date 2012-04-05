# extract subset of columns from CSV
require "csv"

class Masticate::Gsubber < Masticate::Base
  def gsub(opts)
    @output = opts[:output] ? File.open(opts[:output], "w") : $stdout
    csv_options = {}
    csv_options[:col_sep] = opts[:col_sep] if opts[:col_sep]
    csv_options[:quote_char] = opts[:quote_char] || opts[:col_sep] if opts[:quote_char] || opts[:col_sep]

    field = opts[:field] or raise "missing field to gsub"
    from = Regexp.new(opts[:from]) or raise "Invalid regex '#{opts[:from]}' for conversion"
    to = opts[:to] or raise "missing 'to' string for gsub"

    @output_count = 0
    headers = nil
    with_input do |input|
      while line = get
        row = CSV.parse_line(line, csv_options)
        if !headers
          headers = row
          index = headers.index(field) or raise "Unable to find column '#{field}'"
          emit(line)
        else
          oldval = row[index]
          newval = oldval.gsub(from, to)
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
end
