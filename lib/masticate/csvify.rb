# convert input to clean standard CSV

class Masticate::Csvify
  attr_reader :file

  def initialize(file)
    @file = file
  end

  def csvify(opts)
    output = CSV.open(opts[:output])
    CSV.foreach(file, :col_sep => opts[:col_sep]) do |row|
      output << row
    end
  end
end
