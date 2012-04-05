# spec for field regexp conversion

require "spec_helper"
require "tempfile"

describe "gsubbing" do
  it "should apply conversion to a single column" do
    filename = File.dirname(__FILE__) + "/../data/badnums.csv"
    tmp = Tempfile.new('gsubber')
    results = Masticate.gsub(filename, :output => tmp, :field => 'AuditByID', :from => '/,|(.00$)/', :to => '')
    output = File.read(tmp)
    correct_output = File.read(File.dirname(__FILE__) + "/../data/badnums_fixed.csv")

    output.should == correct_output
  end
end
