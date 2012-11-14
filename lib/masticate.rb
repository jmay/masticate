require "open-uri"
require "csv"

%w{version base sniffer mender csvify plucker datify gsubber max_rows concat relabel exclude transform include cook command myoptparse}.each do |f|
  require_relative "masticate/#{f}"
end

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

  def self.concat(filenames, opts)
    Concat.new(filenames).concat(opts)
  end

  def self.relabel(filename, opts)
    Relabel.new(filename).relabel(opts)
  end

  def self.exclude(filename, opts)
    Exclude.new(filename).exclude(opts)
  end

  def self.include(filename, opts)
    Include.new(filename).exclude(opts)
  end

  def self.cook(filename, opts)
    Cook.new(filename).cook(opts)
  end

  def self.transform(filename, opts)
    Transform.new(filename).transform(opts)
  end
end
