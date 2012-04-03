# convert input to clean standard CSV
require "csv"

class Masticate::Csvify
  attr_reader :file

  def initialize(file)
    @file = file
  end

  def csvify(opts)
    csv_options = {}
    csv_options[:col_sep] = opts[:col_sep] if opts[:col_sep]
    csv_options[:quote_char] = opts[:quote_char] || opts[:col_sep] if opts[:quote_char] || opts[:col_sep]
    
    CSV.foreach(file, csv_options) do |row|
      opts[:output] << row.to_csv
    end
  end
end
