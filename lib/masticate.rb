require "masticate/version"
require "masticate/sniffer"
require "masticate/mender"
require "masticate/csvify"

module Masticate
  def self.sniff(file)
    Sniffer.new(file).sniff
  end

  def self.mend(file, opts)
    Mender.new(file).mend(opts)
  end

  def self.csvify(file, opts)
    Csvify.new(file).csvify(opts)
  end
end
