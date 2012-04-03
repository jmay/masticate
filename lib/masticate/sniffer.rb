class Masticate::Sniffer
  attr_reader :file
  attr_reader :col_sep

  CandidateDelimiters = [',', '|', "\t"]

  def initialize(file)
    @file = file
  end

  def self.sniff(file)
    sniffer = new(file)
    sniffer.sniff
  end

  def sniff
    @col_sep = find_col_sep
    {
      :col_sep => col_sep,
      :field_counts => stats
    }
  end

  def find_col_sep
    line1 = file.lines.first
    delimcounts = CandidateDelimiters.each_with_object({}) do |delim,h|
      h[delim] = consider_delim(line1, delim)
    end
    file.seek(0) # reset file pointer
    delimcounts.sort_by{|h,v| -v}.first.first
  end

  def consider_delim(line, delim)
    line.count(delim)
  end

  def stats
    file.lines.map {|line| line.split(col_sep).count}.uniq
  end
end
