# spec for file-sniffing functions

require "spec_helper"

describe "mending" do
  it "should merge lines when delimiter counts don't match'" do
    filename = File.dirname(__FILE__) + "/../data/broken_psv.txt"
    results = Masticate.mend(filename, :col_sep => '|', :output => "/dev/null")
    results[:input_count].should == 7
    results[:output_count].should == 5
  end

  it "should strip trailer records" do
    filename = File.dirname(__FILE__) + "/../data/junk_trailer.txt"
    metadata = Masticate.sniff(filename)
    results = Masticate.mend(filename, metadata.merge(:output => "/dev/null"))
    results[:input_count].should == 9
    results[:output_count].should == 5
    results[:headers].should == ['COL1', 'COL 2', 'Col 3', 'col-4', 'col5', 'col6']
  end

  it "should snip head fields" do
    filename = File.dirname(__FILE__) + "/../data/junk_header.csv"
    results = Masticate.mend(filename, :col_sep => ',', :snip => 1, :output => "/dev/null")
    results[:input_count].should == 6
    results[:output_count].should == 5
    results[:headers].should == %w(hospid usrorder dteorder usrsend dtesend usrdone dtedone department)
  end
end
