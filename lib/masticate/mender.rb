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
    @buried = opts[:buried]

    @expected_field_count = nil
    @holding = ''
  end

  def mend(opts)
    execute(opts)
  end

  def crunch(row, line = '', csv_options = {})
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

      if @buried
        if @buried.is_a?(Fixnum) || @buried =~ /^\d+/
          @buried_index = @buried.to_i
        else
          @buried_index = row.index(@buried) or raise "Unable to find column '#{@buried}'"
        end
      end

      @expected_field_count = @headers.count
      row = @headers
    elsif row
      @holding << ' ' unless @holding.empty?
      @holding << line

      row = CSV.parse_line(@holding, csv_options) #.map {|s| s && s.strip}
      if row
        row = row.map {|s| s && s.strip}
      end

      if row.count < @expected_field_count
        # incomplete row; do not emit anything
        row = nil
      else
        @holding = ''
      end

      if @buried && (row.count > @expected_field_count)
        # buried delimiter
        # take the N+1th field and merge it onto the Nth field, moving up the remaining fields
        row[@buried_index] += row.delete_at(@buried_index + 1)
      end

      if @dejunk && row && row.select {|s| s && !s.strip.empty?}.count <= 2
        # junky row, suppress output
        nil
      else
        row
      end
    end
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
