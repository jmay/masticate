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
        if !headers
          headers = @fields
          emit(headers.to_csv)
        else
          emit(row.to_csv)
        end
      end
    end
    @output.close if opts[:output]

    # File.unlink(opts[:output]) if opts[:output] && File.exists?(opts[:output])
    # redirect = ">>#{opts[:output]}" if opts[:output]
    # 
    # system "/bin/echo -n '#{fields.to_csv}' #{redirect}"
    # system "tail +2 #{@filename} #{redirect}"
  end

  def crunch(row)
    if !@headers
      @headers = @fields
      puts "output #{@headers}"
      row = @headers
    end
    row
  end
end
