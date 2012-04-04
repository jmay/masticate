# spec for file-sniffing functions

require "spec_helper"

describe "mending" do
  it "should merge lines when delimiter counts don't match'" do
    filename = File.dirname(__FILE__) + "/../data/broken_psv.txt"
    results = Masticate.mend(filename, :col_sep => '|', :output => "/dev/null")
    results[:input_records].should == 7
    results[:output_records].should == 5
  end

  it "should strip trailer records" do
    filename = File.dirname(__FILE__) + "/../data/junk_trailer.txt"
    metadata = Masticate.sniff(filename)
    results = Masticate.mend(filename, metadata.merge(:output => "/dev/null"))
    results[:input_records].should == 9
    results[:output_records].should == 5
  end
end
