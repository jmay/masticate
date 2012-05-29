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
    standard_options(opts)

    recipefile = opts[:recipe] or raise "missing recipe for cook"
    recipe = File.read(recipefile).lines
    standard_options(opts)

    # ignore blank lines in recipe file
    steps = recipe.grep(/\S/).map do |step|
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
          row = step.crunch(row) if row
        end

        emit(row) if row
      end
    end
    more_rows = []
    steps.each do |step|
      if more_rows.any?
        more_rows = more_rows.map {|row| step.crunch(row)}
      else
        step.crunch(nil) {|row| more_rows << row}
      end
    end
    more_rows.each {|row| emit(row)}
    # step.crunch(nil) {|row| emit(row)}

    @output.close if opts[:output]

    {
      :input_count => @input_count,
      :output_count => @output_count
    }
  end
end
