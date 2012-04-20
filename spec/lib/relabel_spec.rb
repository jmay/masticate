# spec for file concatenation

require "spec_helper"

describe "relabeling" do
  it "result should be same as original" do
    input = File.dirname(__FILE__) + "/../data/namedcols.csv"
    tmp = Tempfile.new('relabel')
    results = Masticate.relabel(input, :fields => %w{happy birth day to you}, :output => tmp.path)
    output = File.read(tmp)
    tmp.unlink
    correct_output = File.read(File.dirname(__FILE__) + "/../data/relabel_result.csv")
    output.should == correct_output
  end
end
