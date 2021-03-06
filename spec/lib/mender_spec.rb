# spec for file-sniffing functions

require "spec_helper"
require "tempfile"

describe "mending" do
  it "should merge lines when delimiter counts don't match'" do
    filename = File.dirname(__FILE__) + "/../data/broken_psv.txt"
    results = Masticate.mend(filename, :col_sep => '|', :output => "/dev/null")
    results[:input_count].should == 6
    results[:output_count].should == 5
  end

  it "should strip trailer records" do
    filename = File.dirname(__FILE__) + "/../data/junk_trailer.txt"
    results = Masticate.mend(filename, :col_sep => '|', :output => "/dev/null", :dejunk => true)
    results[:input_count].should == 7
    results[:output_count].should == 5
    results[:headers].should == ['COL1', 'COL 2', 'Col 3', 'col-4', 'col5', 'col6']
  end

  it "should snip head fields" do
    filename = File.dirname(__FILE__) + "/../data/junk_header.csv"
    results = Masticate.mend(filename, :col_sep => ',', :snip => 1, :output => "/dev/null")
    results[:input_count].should == 5
    results[:output_count].should == 5
    results[:headers].should == %w(hospid usrorder dteorder usrsend dtesend usrdone dtedone department)
  end

  it "should unfold inlined headers" do
    filename = File.dirname(__FILE__) + "/../data/inlined_headers.csv"
    tmp = Tempfile.new('mending')
    results = Masticate.mend(filename, :col_sep => ',', :quote_char => '"', :inlined => true, :output => tmp)
    output = File.read(tmp)
    correct_output = File.read(File.dirname(__FILE__) + "/../data/inlined_headers.csv.output")

    results[:input_count].should == 10
    results[:output_count].should == 11
    # results[:field_counts].should == {11 => 11}
    output.should == correct_output
  end

  it "should consolidate fields with embedded newlines" do
    filename = File.dirname(__FILE__) + "/../data/newlines_in_input.psv"
    tmp = Tempfile.new('mending')
    results = Masticate.mend(filename, :col_sep => '|', :output => tmp)
    output = File.read(tmp)
    correct_output = File.read(File.dirname(__FILE__) + "/../data/newlines_merged.csv")

    results[:input_count].should == 6
    results[:output_count].should == 4
    output.should == correct_output
  end

  it "should consolidate fields with embedded delimiters" do
    filename = File.dirname(__FILE__) + "/../data/buried_delims_in_input.psv"
    tmp = Tempfile.new('mending')
    results = Masticate.mend(filename, :col_sep => '|', :buried => 'Comment', :output => tmp)
    output = File.read(tmp)
    correct_output = File.read(File.dirname(__FILE__) + "/../data/delims_untangled.csv")

    results[:input_count].should == 4
    results[:output_count].should == 4
    output.should == correct_output
  end
end
