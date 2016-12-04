require "spec_helper"
require 'factory'

describe Parser do
  before do 
    @text = Factory.text
    @p = Parser.new(@text)
  end

  describe(".process") do
    subject { Parser.process(@text) }
    it "creates a new parser instance, parses the `text` and returns the results" do
      expect(subject).not_to be(nil)
      expect(subject.count).to equal(2)
    end
  end

  describe("#new") do
    it "creates a new instance" do
      expect(@p).not_to be(nil)
    end

    it "sets a `text` property with the correct value" do
      expect(@p.text).to equal(@text)
    end
  end
  
  describe("#start") do
    it "parses `text` and stores results in `results`" do
      @p.start
      expect(@p.results).not_to be(nil)
      expect(@p.results.count).to equal(2)
    end
  end
end
