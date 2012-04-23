# cook up a recipe
# * single file as input
# * recipe from a file
# * multiple steps
# * single output

require "shellwords"

class Masticate::Cook < Masticate::Base
  def initialize(filename)
    @filename = filename
  end

  def cook(opts)
    recipefile = opts[:recipe] or raise "missing recipe for cook"
    recipe = File.read(recipefile).lines
    standard_options(opts)

    steps = recipe.map do |step|
      # puts step
      argv = Shellwords.split(step)
      masticator = Masticate::MyOptionParser.new
      command, options = masticator.parse(argv)
      masticator.prepare(command, options)
    end

    @output_count = 0
    headers = nil
    with_input do |input|
      while line = get
        row = CSV.parse_line(line, csv_options)

        steps.each do |step|
          puts "APPLY #{step} to #{row}"
          row = step.crunch(row)
        end

        emit(row.to_csv) if row
      end
    end
    @output.close if opts[:output]

    {
      :input_count => @input_count,
      :output_count => @output_count
    }
  end
end
