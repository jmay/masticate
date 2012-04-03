# spec for file-sniffing functions

require "spec_helper"

describe "delimiter sniffing" do
  it "should find tab delimiter" do
    filename = File.dirname(__FILE__) + "/../data/tabbed_data.txt"
    file = File.open(filename)
    results = Masticate.sniff(file)
    results[:col_sep].should == "\t"
    results[:field_counts].should == [6]
  end

  it "should find pipe delimiter" do
    filename = File.dirname(__FILE__) + "/../data/pipe_data.txt"
    file = File.open(filename)
    results = Masticate.sniff(file)
    results[:col_sep].should == '|'
    results[:field_counts].should == [6]
  end
end
