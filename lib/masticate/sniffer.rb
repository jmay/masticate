class Masticate::Sniffer
  attr_reader :col_sep, :stats

  CandidateDelimiters = [',', '|', "\t"]

  def initialize(filename)
    @filename = filename
  end

  def sniff
    @col_sep = find_col_sep
    @stats = stats
    {
      :col_sep => @col_sep,
      :field_counts => @stats,
      :line1 => @line1
    }
  end

  def find_col_sep
    input = open(@filename)
    @line1 = input.lines.first
    delimcounts = CandidateDelimiters.each_with_object({}) do |delim,h|
      h[delim] = consider_delim(@line1, delim)
    end
    input.close
    delimcounts.sort_by{|h,v| -v}.first.first
  end

  def consider_delim(line, delim)
    line.count(delim)
  end

  def stats
    input = open(@filename)
    counts = input.lines.each_with_object(Hash.new(0)) {|line, counts| counts[line.split(col_sep).count] += 1}
    input.close
    counts
  end
end
