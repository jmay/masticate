# convert input to clean standard CSV
require "csv"

class Masticate::Csvify < Masticate::Base
  def initialize(filename)
    @filename = filename
  end

  def csvify(opts)
    @output = opts[:output] ? File.open(opts[:output], "w") : $stdout
    csv_options = {}
    csv_options[:col_sep] = opts[:col_sep] if opts[:col_sep]
    csv_options[:quote_char] = opts[:quote_char] || opts[:col_sep] if opts[:quote_char] || opts[:col_sep]

    @output_count = 0
    with_input do |input|
      while line = get
        row = CSV.parse_line(line, csv_options)
        emit(row.to_csv) if row
      end
    end
    @output.close if opts[:output]

    {
      :input_count => input_count,
      :output_count => @output_count
    }
  end
end
