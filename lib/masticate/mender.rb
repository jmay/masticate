# repair delimited input files
#
# A row that contains fewer delimiters than expected has been split across two lines
# (due to a newline embedded in a field).  Glue those two lines into a single line in the output.

class Masticate::Mender < Masticate::Base
  def configure(opts)
    standard_options(opts)

    @inlined = opts[:inlined]
    @snip = opts[:snip]
    @dejunk = opts[:dejunk]

    @expected_field_count = nil
    @holding = []
  end

  # attr_reader :col_sep

  # def initialize(filename)
  #   @filename = filename
  # end

  def mend(opts)
    execute(opts)
  end

  def crunch(row)
    if @inlined
      if row
        ncells = row.count/2-1
        if !@headers
          @headers = row[0..ncells]
          @expected_field_count = @headers.count
          emit(@headers)
        else
          if row[0..ncells] != @headers
            raise "Header mismatch on line #{@input_count}\n  Expected: #{@headers.join(',')}\n     Found: #{row[0..ncells].join(',')}"
          end
        end
        row = row[ncells+1, @expected_field_count]
      end
    elsif !@headers
      # trust the first row
      @headers = row
      case @snip
      when Fixnum
        @headers.shift(@snip)
      when String
        raise "TODO: snip named header. Multiple?"
      when nil
        # do nothing
      else
        raise "Do not understand snip instruction [#{@snip.inspect}]"
      end
      @expected_field_count = @headers.count
      row = @headers
    elsif row
      @holding += row
      if @holding.count < @expected_field_count
        # incomplete row; do not emit anything
        row = nil
      else
        row = @holding
        @holding = []
      end

      if @dejunk && row && row.select {|s| s && !s.strip.empty?}.count <= 2
        # junky row, suppress output
        nil
      else
        row
      end
    end
  end

  def old_mend(opts)
    @output = opts[:output] ? File.open(opts[:output], "w") : $stdout
    @col_sep = opts[:col_sep] || ','
    @quote_char = opts[:quote_char] || "\0"

    expected_field_count = nil
    headers = nil
    @output_count = 0
    fieldcounts = Hash.new(0)
    with_input do |input|
      while (line = get) do
        unless line =~ /^\s*$/
          if opts[:inlined]
            row = explode(line)
            ncells = row.count/2-1
            if !expected_field_count
              headers = row[0..ncells]
              expected_field_count = headers.count
              fieldcounts[headers.count] += 1
              emit(headers.to_csv(:col_sep => @col_sep))
            else
              if row[0..ncells] != headers
                raise "Header mismatch on line #{@input_count}\n  Expected: #{headers.join(',')}\n     Found: #{row[0..ncells].join(',')}"
              end
            end
            row = row[ncells+1, expected_field_count]
            fieldcounts[row.count] += 1
            emit(row.to_csv(:col_sep => @col_sep))
          elsif !expected_field_count
            # trust the first row
            headers = explode(line).map(&:strip)
            case opts[:snip]
            when Fixnum
              headers.shift(opts[:snip])
            when String
              raise "TODO: snip named header. Multiple?"
            when nil
              # do nothing
            else
              raise "Do not understand snip instruction [#{opts[:snip].inspect}]"
            end
            expected_field_count = headers.count
            fieldcounts[headers.count] += 1
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

            unless opts[:dejunk] && junky?(line)
              fieldcounts[fieldcount(line)] += 1
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
      :field_counts => fieldcounts,
      :headers => headers
    }
  end

  def fieldcount(line)
    explode(line).count
  end

  def explode(line)
    CSV.parse_line(line, :col_sep => @col_sep, :quote_char => @quote_char).map {|s| s && s.strip}
  end

  # a line is "junky" if it has 2 or fewer fields with any content
  def junky?(line)
    explode(line).select {|s| s && !s.strip.empty?}.count <= 2
  end
end
