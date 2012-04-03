# spec for file-sniffing functions

require "spec_helper"

describe "mending" do
  it "should find tab delimiter" do
    filename = File.dirname(__FILE__) + "/../data/broken_psv.txt"
    file = File.open(filename)
    devnull = File.open('/dev/null', 'w')
    results = Masticate.mend(file, :output => devnull, :col_sep => '|')
    results[:input_records].should == 6
    results[:output_records].should == 5
  end
end
