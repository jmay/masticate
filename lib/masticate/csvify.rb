# convert input to clean standard CSV
require "csv"

class Masticate::Csvify
  attr_reader :file

  def initialize(file)
    @file = file
  end

  def csvify(opts)
    CSV.foreach(file, :col_sep => opts[:col_sep]) do |row|
      opts[:output] << row.to_csv
    end
  end
end
