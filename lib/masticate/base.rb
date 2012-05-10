class Masticate::Base
  attr_reader :filename
  attr_reader :input, :output
  attr_reader :input_count, :output_count
  attr_reader :csv_options

  def initialize(args)
    case args
    when String, nil
      @filename = args
    when Hash
      configure(args)
    else
      raise "invalid initialization: #{args}"
    end
  end

  def with_input
    @input = @filename ? open(@filename) : $stdin
    @input_count = 0
    result = yield @input
    @input.close if @filename
    result
  end

  def get
    line = @input.gets
    @input_count += 1
    line && line.chomp
  end

  def emit(line)
    @output_count ||= 0
    @output_count += 1
    begin
      case line
      when Array
        @output.puts line.to_csv
      else
        @output.puts line
      end
    rescue Errno::EPIPE
      # output was closed, e.g. ran piped into `head`
      # silently ignore this condition, it's not fatal and doesn't need a warning
    end
  end

  def standard_options(opts)
    @output = opts[:output] ? File.open(opts[:output], "w") : $stdout
    @csv_options = {}
    @csv_options[:col_sep] = opts[:col_sep] if opts[:col_sep]
    if opts[:col_sep]
      @csv_options[:quote_char] = opts[:quote_char] || "\0"
    end
  end

  def execute(opts)
    configure(opts)

    @output_count = 0
    with_input do |input|
      while line = get
        row = CSV.parse_line(line, csv_options) #.map {|s| s && s.strip}
        if row
          row = row.map {|s| s && s.strip}
        end
        # row2 = row.map {|s| s && s.strip}
        # if row2.nil?
        #   puts "**** ROW IS [#{row.inspect}]"
        # end
        output = crunch(row)
        emit(output) if output
      end
    end
    crunch(nil) {|row| emit(row)}
    @output.close if opts[:output]

    {
      :input_count => input_count,
      :output_count => @output_count,
      :headers => @headers
    }
  end
end
