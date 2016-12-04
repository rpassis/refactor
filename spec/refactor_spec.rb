require "spec_helper"

describe Refactor do
  
  it "has a version number" do
    expect(Refactor::VERSION).not_to be nil
  end

  before do
    dir = Pathname(fixture_path('RefactorSampleProject'))
    @refactor = Refactor.new({path: dir})
  end

  describe("#files") do
    it "lists all files for the given folder" do
      expect(@refactor.files.count).to be > 0
    end
  end

  describe("#parse") do
    it "parses the matching files" do
      expect(@refactor.parse).to be(true)
    end
  end
end
