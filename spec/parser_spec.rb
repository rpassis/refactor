require "spec_helper"
require 'factory/source_code'

describe Parser do
  before do 
    @s = Factory::SourceCode.new
    @p = Parser.new(@s.text)
  end

  describe(".process") do
    subject { Parser.process(@s.text) }
    it "creates a new parser instance, parses the `text` and returns the results" do
      expect(subject).not_to be(nil)
      expect(subject.count).to equal(@s.number_of_files)
    end
  end

  describe("#new") do
    it "creates a new instance" do
      expect(@p).not_to be(nil)
    end

    it "sets a `text` property with the correct value" do
      expect(@p.text).to eq(@s.text)
    end
  end
  
  describe("#start") do
    it "parses `text` and stores results in `results`" do
      @p.start
      expect(@p.results).not_to be(nil)
      expect(@p.results.count).to equal(@s.number_of_files)
    end
  end

  describe("#modified_source_text") do
    it "returns a modified version of the original text that excludes parsed lines" do
      @p.start
      expect(@p.modified_source_text).to eq(@s.modified_text)
    end
  end
end
