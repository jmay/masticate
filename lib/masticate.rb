require "open-uri"

require_relative "masticate/version"
require_relative "masticate/sniffer"
require_relative "masticate/mender"
require_relative "masticate/csvify"

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
