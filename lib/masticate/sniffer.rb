class Masticate::Sniffer < Masticate::Base
  attr_reader :col_sep, :quote_char, :stats
  attr_reader :delimstats

  CandidateDelimiters = [',', '|', "\t"]

  def initialize(filename)
    @filename = filename
  end

  def sniff
    @col_sep = find_col_sep
    @quote_char = delimstats[@col_sep][:quote_char]
    @stats = stats
    {
      :col_sep => @col_sep,
      :quote_char => @quote_char,
      :field_counts => @stats,
      :headers => @line1.split(@col_sep).map(&:strip)
    }
  end

  def find_col_sep
    @delimstats = {}
    with_input do |input|
      input.lines.take(10).each do |line|
        @line1 = line unless @line1

        CandidateDelimiters.each do |delim|
          delimstats[delim] ||= { :counts => Set.new, :quote_char => nil}
          h = delimstats[delim]
          fieldcount, quote_char = consider_delim(line, delim)
          h[:counts] << fieldcount
          h[:quote_char] ||= quote_char
        end
      end
    end
    delimstats.sort_by{|delim,stats| stats[:counts].max || 0}.last.first
  end

  def consider_delim(line, delim)
    @quote_char = nil
    n = count_fields(line, delim)
    [n, @quote_char]
  end

  def count_fields(line, delim)
    if delim == ','
      straight_count = line.count(delim) + 1
      count_with_quoting = begin
        CSV.parse_line(line).count
      rescue CSV::MalformedCSVError
        # this is not valid CSV, e.g. has incorrectly embedded quotes
        0
      end
      if count_with_quoting < straight_count
        @quote_char = '"'
        count_with_quoting
      else
        straight_count
      end
    else
      line.count(delim) + 1
    end
  end

  def stats
    counts = with_input do |input|
      if col_sep == ',' && quote_char
        input.lines.each_with_object(Hash.new(0)) {|line, counts| counts[CSV.parse_line(line, :quote_char => quote_char).count] += 1}
      else
        input.lines.each_with_object(Hash.new(0)) {|line, counts| counts[line.split(col_sep).count] += 1}
      end
    end
    counts
  end
end
