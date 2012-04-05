# spec for file-sniffing functions

require "spec_helper"

describe "delimiter sniffing" do
  it "should find tab delimiter" do
    filename = File.dirname(__FILE__) + "/../data/tabbed_data.txt"
    results = Masticate.sniff(filename)
    results[:col_sep].should == "\t"
    results[:field_counts].should == {6 => 5}
  end

  it "should find pipe delimiter" do
    filename = File.dirname(__FILE__) + "/../data/pipe_data.txt"
    results = Masticate.sniff(filename)
    results[:col_sep].should == '|'
    results[:field_counts].should == {6 => 5}
  end

  it "should recognize quotes in CSV sources" do
    filename = File.dirname(__FILE__) + "/../data/quoted_csv_data.txt"
    results = Masticate.sniff(filename)
    results[:col_sep].should == ','
    results[:quote_char].should == '"'
    results[:field_counts].should == {14 => 100}
  end
end
