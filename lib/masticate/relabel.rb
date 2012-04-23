# relabel a single input file
# * assuming that input file has a single header line
# * assuming that input file is in valid CSV format (no validation)

class Masticate::Relabel < Masticate::Base
  def configure(opts)
    standard_options(opts)

    @fields = opts[:fields] or raise "missing fieldnames for relabel"
  end

  def relabel(opts)
    configure(opts)

    @output_count = 0
    headers = nil
    with_input do |input|
      while line = get
        row = CSV.parse_line(line, csv_options)
        emit crunch(row)
      end
    end
    @output.close if opts[:output]
  end

  def crunch(row)
    if !@headers
      @headers = @fields
      row = @headers
    end
    row
  end
end
