# convert input to clean standard CSV
require "csv"

class Masticate::Csvify < Masticate::Base
  def initialize(filename)
    @filename = filename
  end

  def csvify(opts)
    standard_options(opts)

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
