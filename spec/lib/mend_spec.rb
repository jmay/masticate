# spec for file-sniffing functions

require "spec_helper"

describe "mending" do
  it "should merge lines when delimiter counts don't match'" do
    filename = File.dirname(__FILE__) + "/../data/broken_psv.txt"
    results = Masticate.mend(filename, :output => "/dev/null", :col_sep => '|')
    results[:input_records].should == 6
    results[:output_records].should == 5
  end
end
