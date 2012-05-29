# spec for cookery

require "spec_helper"

describe "cooking up a recipe" do
  it "should handle multiple steps" do
    input = File.dirname(__FILE__) + "/../data/quoted_csv_data.txt"
    recipe = File.dirname(__FILE__) + "/../data/recipe.txt"
    tmp = Tempfile.new('cooked')
    results = Masticate.cook(input, :output => tmp, :recipe => recipe)
    output = File.read(tmp)
    correct_output = File.read(File.dirname(__FILE__) + "/../data/cooking_result.csv")
  
    output.should == correct_output
  end

  it "should allow mend in recipe" do
    input = File.dirname(__FILE__) + "/../data/broken_psv.txt"
    recipe = File.dirname(__FILE__) + "/../data/recipe_mend.txt"
    tmp = Tempfile.new('cooked')
    results = Masticate.cook(input, :col_sep => '|', :output => tmp, :recipe => recipe)
    output = File.read(tmp)
    correct_output = File.read(File.dirname(__FILE__) + "/../data/cooking_mend_result.csv")
  
    output.should == correct_output
  end

  it "should do correct datify & gsub in recipe" do
    input = File.dirname(__FILE__) + "/../data/cookery_input.psv"
    recipe = File.dirname(__FILE__) + "/../data/recipe_cookery.txt"
    tmp = Tempfile.new('cooked')
    results = Masticate.cook(input, :col_sep => '|', :output => tmp, :recipe => recipe)
    output = File.read(tmp)
    correct_output = File.read(File.dirname(__FILE__) + "/../data/cookery_result.csv")
  
    output.should == correct_output
  end
end
