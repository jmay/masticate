# repair delimited input files
#
# A row that contains fewer delimiters than expected has been split across two lines
# (due to a newline embedded in a field).  Glue those two lines into a single line in the output.

class Masticate::Mender < Masticate::Base
  attr_reader :col_sep

  def initialize(filename)
    @filename = filename
  end

  def mend(opts)
    @output = opts[:output] ? File.open(opts[:output], "w") : $stdout
    @col_sep = opts[:col_sep] || ','

    expected_field_count = nil
    headers = nil
    @output_count = 0
    with_input do |input|
      while (line = get) do
        unless line =~ /^\s*$/
          if !expected_field_count
            # trust the first row
            headers = explode(line)
            case opts[:snip]
            when Fixnum
              headers.shift(opts[:snip])
            when nil
              # do nothing
            else
              raise "Do not understand snip instruction [#{opts[:snip].inspect}]"
            end
            expected_field_count = headers.count
            emit(headers.to_csv(:col_sep => @col_sep))
          else
            running_count = fieldcount(line)
            while !input.eof? && running_count < expected_field_count do
              nextbit = get
              if nextbit
                line = line + ' ' + nextbit
                running_count = fieldcount(line)
              end
            end

            if line.count(col_sep) > 2
              emit(line)
            end
          end
        end
      end
    end

    @output.close if opts[:output]
    {
      :input_count => @input_count,
      :output_count => @output_count,
      :headers => headers
    }
  end

  def fieldcount(line)
    if col_sep == ','
      CSV.parse_line(line).count
    else
      line.count(col_sep)+1
    end
  end

  def explode(line)
    if col_sep == ','
      CSV.parse_line(line).map(&:strip)
    else
      line.split(col_sep).map(&:strip)
    end
  end
end
