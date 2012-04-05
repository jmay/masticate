# repair delimited input files
#
# A row that contains fewer delimiters than expected has been split across two lines
# (due to a newline embedded in a field).  Glue those two lines into a single line in the output.

class Masticate::Mender < Masticate::Base
  def initialize(filename)
    @filename = filename
  end

  def mend(opts)
    @output = opts[:output] ? File.open(opts[:output], "w") : $stdout
    col_sep = opts[:col_sep]

    expected_delim_count = nil
    @output_count = 0
    with_input do |input|
      while (line = get) do
        unless line =~ /^\s*$/
          if !expected_delim_count
            # trust the first row
            expected_delim_count = line.count(col_sep)
          else
            running_count = line.count(col_sep)
            while !input.eof? && running_count < expected_delim_count do
              nextbit = get
              if nextbit
                line = line + ' ' + nextbit
                running_count = line.count(col_sep)
              end
            end
          end
          if line.count(col_sep) > 2
            emit(line)
          end
        end
      end
    end

    @output.close if opts[:output]
    {
      :input_records => @input_count,
      :output_records => @output_count
    }
  end
end
