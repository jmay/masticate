require "open-uri"

require "masticate/version"
require "masticate/sniffer"
require "masticate/mender"
require "masticate/csvify"

module Masticate
  def self.sniff(filename)
    Sniffer.new(filename).sniff
  end

  def self.mend(filename, opts)
    Mender.new(filename).mend(opts)
  end

  def self.csvify(filename, opts)
    Csvify.new(filename).csvify(opts)
  end
end
