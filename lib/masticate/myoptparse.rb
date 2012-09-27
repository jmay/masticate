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

      # if I specify String here, then a blank string '' is considered invalid and triggers an exception.
      opts.on("--value VALUE", "(*exclude* only) Value to compare field to for exclusion") do |s|
        @options[:value] = s
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

      opts.on("--rule {downcase,upcase}", String, "(*transform* only) Transformation rule") do |f|
        @options[:rule] = f
      end

      opts.on("--buried FIELD", String, "(*mend* only) Remove embedded delimiters from named field") do |f|
        @options[:buried] = f
      end
    end
  end

  def parse(argv = ARGV)
    @command = argv.shift
    filenames = @parser.parse(argv)
    # argv remnants are filenames
    [@command, @options, filenames]
  end

  def prepare(command, options)
    klasses = {
      'gsub' => Masticate::Gsubber,
      'transform' => Masticate::Transform,
      'datify' => Masticate::Datify,
      'maxrows' => Masticate::MaxRows,
      'relabel' => Masticate::Relabel,
      'pluck' => Masticate::Plucker,
      'exclude' => Masticate::Exclude,
      'mend' => Masticate::Mender
    }

    klass = klasses[command]
    klass.new(options)
  end

  def execute(command, options, filenames = nil)
    filename = filenames.first

    case command
    when 'sniff'
      results = Masticate.sniff(filename, options)
      col_sep = results[:col_sep]
      col_sep = "TAB" if col_sep == "\t"
      quote_char = results[:quote_char] || "NONE"
      $stderr.puts <<-EOT
Processing complete.
  Input delimiter: #{col_sep}
  Quote char: #{quote_char}
  Field counts: #{results[:field_counts].inspect}
  Headers: #{results[:headers].join(',')}
EOT

    when 'mend'
      results = Masticate.mend(filename, options)
      logmessage(command, options, results)

    when 'csvify'
      results = Masticate.csvify(filename, options)
      logmessage(command, options, results)

    when 'pluck'
      results = Masticate.pluck(filename, options)
      logmessage(command, options, results)

    when 'datify'
      results = Masticate.datify(filename, options)
      logmessage(command, options, results)

    when 'gsub'
      results = Masticate.gsub(filename, options)
      logmessage(command, options, results)

    when 'maxrows'
      results = Masticate.maxrows(filename, options)
      logmessage(command, options, results)

    when 'concat'
      results = Masticate.concat(ARGV, options)
      # logmessage(command, options, results)

    when 'relabel'
      results = Masticate.relabel(filename, options)
      # logmessage(command, options, results)

    when 'cook'
      results = Masticate.cook(filename, options)
      logmessage(command, options, results)

    when 'exclude'
      results = Masticate.exclude(filename, options)
      logmessage(command, options, results)

    when 'transform'
      results = Masticate.transform(filename, options)
      logmessage(command, options, results)

    else
      raise "unknown command #{command}"
    end
  end

  def logmessage(command, options, results)
    $stderr.puts <<-EOT
* masticate #{command} (#{options.keys.join(', ')})
  Lines in input: #{results[:input_count]}
  Lines in output: #{results[:output_count]}
  Headers: #{results[:headers].inspect}
EOT
    if results[:field_counts]
      $stderr.puts "  Field counts: #{results[:field_counts].inspect}"
    end
  end
end
