class Masticate::Sniffer < Masticate::Base
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
      :headers => @line1.split(@col_sep).map(&:strip)
    }
  end

  def find_col_sep
    delimcounts = with_input do |input|
      @line1 = input.lines.first
      CandidateDelimiters.each_with_object({}) do |delim,h|
        h[delim] = consider_delim(@line1, delim)
      end
    end
    delimcounts.sort_by{|h,v| -v}.first.first
  end

  def consider_delim(line, delim)
    line.count(delim)
  end

  def stats
    counts = with_input do |input|
      input.lines.each_with_object(Hash.new(0)) {|line, counts| counts[line.split(col_sep).count] += 1}
    end
    counts
  end
end
