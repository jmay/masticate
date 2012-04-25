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
        if row
          row = row.map(&:strip)
          emit(row)
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
