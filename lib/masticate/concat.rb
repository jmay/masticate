# concatenate input files:
# * assuming that each input file has a single header line
# * writing a single header line to the output (just use the header line from the first file)
# * trying that all the files have the same format (no validation)

class Masticate::Concat #< Masticate::Base
  def initialize(filenames)
    @filenames = filenames
  end

  def concat(opts)
    File.unlink(opts[:output]) if opts[:output] && File.exists?(opts[:output])
    redirect = ">>#{opts[:output]}" if opts[:output]
    
    file1, *rest = @filenames
    system "cat #{file1} #{redirect}"
    rest.each do |file|
      system "tail -n +2 #{file} #{redirect}"
    end
  end
end
