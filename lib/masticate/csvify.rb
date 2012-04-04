# convert input to clean standard CSV
require "csv"

class Masticate::Csvify
  attr_reader :input

  def initialize(filename)
    @input = File.open(filename)
  end

  def csvify(opts)
    @output = opts[:output] ? File.open(opts[:output], "w") : $stdout
    csv_options = {}
    csv_options[:col_sep] = opts[:col_sep] if opts[:col_sep]
    csv_options[:quote_char] = opts[:quote_char] || opts[:col_sep] if opts[:quote_char] || opts[:col_sep]

    input_count = @output_count = 0
    CSV.foreach(input, csv_options) do |row|
      input_count += 1
      emit(row.to_csv)
    end
    @output.close if opts[:output]
    @input.close
    {
      :input_count => input_count,
      :output_count => @output_count
    }
  end

  def emit(line)
    @output_count += 1
    begin
      @output.puts line
    rescue Errno::EPIPE
      # output was closed, e.g. ran piped into `head`
      # silently ignore this condition, it's not fatal and doesn't need a warning
    end
  end
end
