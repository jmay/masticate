# convert date columns to numerics
require "csv"

class Masticate::Datify < Masticate::Base
  def datify(opts)
    standard_options(opts)

    field = opts[:field] or raise "missing field to datify"
    format = opts[:format] or raise "strptime format required for parsing timestamps"

    @output_count = 0
    headers = nil
    with_input do |input|
      while line = get
        row = CSV.parse_line(line, csv_options)
        if !headers
          headers = row
          index = headers.index(field) or raise "Unable to find column '#{field}'"
          emit(headers.to_csv)
        else
          row[index] = DateTime.strptime(row[index], format).to_time.to_i rescue nil
          emit(row.to_csv)
        end
      end
    end
    @output.close if opts[:output]

    {
      :input_count => @input_count,
      :output_count => @output_count
    }
  end
end
