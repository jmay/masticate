# spec for column-plucking functions

require "spec_helper"
require "tempfile"

describe "plucker" do
  it "should pull named columns" do
    filename = File.dirname(__FILE__) + "/../data/namedcols.csv"
    tmp = Tempfile.new('plucker')
    results = Masticate.pluck(filename, :output => tmp, :fields => ['three', '5'])
    output = File.read(tmp)
    correct_output = File.read(File.dirname(__FILE__) + "/../data/namedcols.csv.output")
    tmp.unlink

    results[:input_count].should == 4
    output.should == correct_output
  end

  it "should pull numbered columns starting at 1" do
    filename = File.dirname(__FILE__) + "/../data/namedcols.csv"
    tmp = Tempfile.new('plucker')
    results = Masticate.pluck(filename, :output => tmp, :fields => [3,5])
    output = File.read(tmp)
    correct_output = File.read(File.dirname(__FILE__) + "/../data/namedcols.csv.output")
    tmp.unlink

    results[:input_count].should == 4
    output.should == correct_output
  end
end
