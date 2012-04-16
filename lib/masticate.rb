require "open-uri"

require_relative "masticate/version"
require_relative "masticate/base"
require_relative "masticate/sniffer"
require_relative "masticate/mender"
require_relative "masticate/csvify"
require_relative "masticate/plucker"
require_relative "masticate/datify"
require_relative "masticate/gsubber"
require_relative "masticate/max_rows"

module Masticate
  def self.sniff(filename, opts = {})
    Sniffer.new(filename).sniff(opts)
  end

  def self.mend(filename, opts)
    Mender.new(filename).mend(opts)
  end

  def self.csvify(filename, opts)
    Csvify.new(filename).csvify(opts)
  end

  def self.pluck(filename, opts)
    Plucker.new(filename).pluck(opts)
  end

  def self.datify(filename, opts)
    Datify.new(filename).datify(opts)
  end

  def self.gsub(filename, opts)
    Gsubber.new(filename).gsub(opts)
  end

  def self.maxrows(filename, opts)
    MaxRows.new(filename).maxrows(opts)
  end
end
