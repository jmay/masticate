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

  # it "should sniff files on the web" do
  #   uri = "http://www.example.com/somedata.dat"
  # 
  #   Masticate::Sniffer.any_instance.stub(:open).and_return(File.dirname(__FILE__) + "/../data/pipe_data.txt")
  #   Masticate::Sniffer.any_instance.should_receive(:open).with(uri)
  # 
  #   results = Masticate.sniff(uri)
  #   results[:col_sep].should == '|'
  #   results[:field_counts].should == [6]
  # end
end
