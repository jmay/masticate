# relabel a single input file
# * assuming that input file has a single header line
# * assuming that input file is in valid CSV format (no validation)

class Masticate::Relabel < Masticate::Base
  def initialize(filename)
    @filename = filename
  end

  def relabel(opts)
    fields = opts[:fields] or raise "missing fieldnames for relabel"

    File.unlink(opts[:output]) if opts[:output] && File.exists?(opts[:output])
    redirect = ">>#{opts[:output]}" if opts[:output]

    system "/bin/echo -n '#{fields.to_csv}' #{redirect}"
    system "tail +2 #{@filename} #{redirect}"
  end
end
