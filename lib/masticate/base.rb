class Masticate::Base
  attr_reader :input, :output
  attr_reader :input_count, :output_count

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
    @output_count += 1
    begin
      @output.puts line
    rescue Errno::EPIPE
      # output was closed, e.g. ran piped into `head`
      # silently ignore this condition, it's not fatal and doesn't need a warning
    end
  end
end
