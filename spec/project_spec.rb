require "spec_helper"

describe Refactor::Project do
  
  it "has a version number" do
    expect(Refactor::VERSION).not_to be nil
  end

  before do
    xcodeproj = fixture_path('RefactorSampleProject/RefactorSampleProject.xcodeproj')
    @refactor = Refactor::Project.open(xcodeproj)
  end

  describe("#files") do
    it "lists all files for the given folder" do
      @refactor.files.each { |f| puts f.path }
      expect(@refactor.files.count).to equal 10
    end
  end

  describe("#swift_files") do
    it "lists all swift files for the given folder" do      
      @refactor.swift_files.each { |f| puts f.path }
      expect(@refactor.swift_files.count).to equal 3
    end
  end
  
  describe("#parse") do
    it "parses the matching files" do
      result = @refactor.parse
      expect(result).not_to be(nil)
      expect(result.count).to eq 2
      # cleanup_files(result)
    end
  end
end
