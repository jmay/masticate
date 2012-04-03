require "masticate/version"
require "masticate/sniffer"
require "masticate/mender"

module Masticate
  def self.sniff(file)
    Sniffer.new(file).sniff
  end

  def self.mend(file, opts)
    Mender.new(file).mend(opts)
  end
end
