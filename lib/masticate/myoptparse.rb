require "optparse"

class Masticate::MyOptionParser
  attr_reader :command, :options

  def initialize
    @options = {}
    @parser = OptionParser.new do |opts|
      opts.banner = "Usage: masticate [command] [options]"

      opts.on("--output FILENAME", String, "Redirect output from stdout to file") do |f|
        @options[:output] = f
      end

      opts.on("--format FORMAT", String, "Specify format") do |v|
        @options[:format] = v
      end

      opts.on("--delim DELIMITER", String, "Specify field delimiter (character or TAB; default is ',')") do |v|
        @options[:col_sep] = v
        @options[:col_sep] = "\t" if @options[:col_sep] == "TAB"
      end

      opts.on("--quote QUOTE-CHAR", String, "Specify character used for quoting fields (optional; default is no quoting)") do |char|
        @options[:quote_char] = char
      end

      opts.on("--stats", "(for *sniff*) collect & display input stats") do
        @options[:stats] = true
      end

      opts.on("--fields LIST", Array, "Specify fields to select") do |list|
        @options[:fields] = list
      end

      opts.on("--field FIELD", String, "Specify field to convert") do |f|
        @options[:field] = f
      end

      opts.on("--snip DIRECTIVE", String, "Specify header fields to snip: first N, or by name") do |f|
        @options[:snip] = f.to_i
      end

      opts.on("--from REGEXP", String, "Regular expression for gsub conversion") do |s|
        @options[:from] = s
      end

      # if I specify String here, then a blank string '' is considered invalid and triggers an exception.
      opts.on("--to STRING", "Result string for gsub conversion") do |s|
        @options[:to] = s
      end

      opts.on("--inlined", "(for *mend* only) Source file has headers inlined on each line") do |b|
        @options[:inlined] = true
      end

      opts.on("--dejunk", "(for *mend* only) Expunge junk lines from source") do |b|
        @options[:dejunk] = true
      end

      opts.on("--by FIELD", String, "(for *maxrows* only) Field to group by") do |f|
        @options[:by] = f
      end

      opts.on("--max FIELD", String, "(for *maxrows* only) Field to find max value for") do |f|
        @options[:max] = f
      end

      opts.on("--recipe FILENAME", String, "(*cook* only) Recipe file") do |f|
        @options[:recipe] = f
      end
    end
  end

  def parse(argv = ARGV)
    @command = argv.shift
    filenames = @parser.parse(argv)
    # argv remnants are filenames
    [@command, @options, filenames]
  end
end
