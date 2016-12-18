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
      @refactor.files.each { |f| puts f.path }
      expect(@refactor.files.count).to equal 10
    end
  end
  
  describe("#parse") do
    it "parses the matching files" do
      expect(@refactor.parse).to be(true)
    end
  end
end

def cleanup_files(files)
  files.each { |f| File.delete(f.real_path) }
end