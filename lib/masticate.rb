require "masticate/version"
require "masticate/sniffer"

module Masticate
  def self.sniff(file)
    Sniffer.new(file).sniff
  end
end
