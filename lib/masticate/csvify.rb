# convert input to clean standard CSV
require "csv"

class Masticate::Csvify
  attr_reader :input

  def initialize(filename)
    @input = File.open(filename)
  end

  def csvify(opts)
    output = opts[:output] ? File.open(opts[:output], "w") : $stdout
    csv_options = {}
    csv_options[:col_sep] = opts[:col_sep] if opts[:col_sep]
    csv_options[:quote_char] = opts[:quote_char] || opts[:col_sep] if opts[:quote_char] || opts[:col_sep]

    input_count = output_count = 0
    CSV.foreach(input, csv_options) do |row|
      input_count += 1
      output << row.to_csv
      output_count += 1
    end
    output.close
    @input.close
    {
      :input_count => input_count,
      :output_count => output_count
    }
  end
end
