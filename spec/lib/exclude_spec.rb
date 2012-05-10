# spec for row exclusion

require "spec_helper"

describe "exclude" do
  it "should be able to ignore rows with blank fields" do
    filename = File.dirname(__FILE__) + "/../data/exclude_input.csv"
    tmp = Tempfile.new('exclude')
    results = Masticate.exclude(filename, :output => tmp, :field => 'ID', :value => '')
    output = File.read(tmp)
    correct_output = File.read(File.dirname(__FILE__) + "/../data/exclude_results.csv")

    output.should == correct_output
  end

  it "should be able to exclude rows by number as well as name" do
    filename = File.dirname(__FILE__) + "/../data/exclude_input.csv"
    tmp = Tempfile.new('exclude')
    results = Masticate.exclude(filename, :output => tmp, :field => 1, :value => '')
    output = File.read(tmp)
    correct_output = File.read(File.dirname(__FILE__) + "/../data/exclude_results.csv")

    output.should == correct_output
  end
end
