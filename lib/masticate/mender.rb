# repair delimited input files
#
# A row that contains fewer delimiters than expected has been split across two lines
# (due to a newline embedded in a field).  Glue those two lines into a single line in the output.

class Masticate::Mender
  attr_reader :input

  def initialize(filename)
    @input = open(filename)
  end

  def mend(opts)
    output = opts[:output] ? File.open(opts[:output], "w") : $stdout
    col_sep = opts[:col_sep]

    expected_count = nil
    @input_count = output_count = 0
    while (line = get) do
      if !expected_count
        # trust the first row
        expected_count = line.count(col_sep)
      else
        running_count = line.count(col_sep)
        until line.nil? || running_count >= expected_count
          nextbit = get
          if nextbit
            line = line.chomp + ' ' + nextbit
            running_count = line.count(col_sep)
          else
            line = nil
          end
        end
      end
      output_count += 1
      output << line
    end

    @input.close
    output.close
    {
      :input_records => @input_count,
      :output_records => output_count
    }
  end

  def get
    (line = input.gets) && @input_count += 1
    line
  end
end
