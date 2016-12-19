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
    pending "parses the matching files"
  end

  describe("#update_with") do
    it "updates the xcodeproj with given files and respective paths" do      
      project_dir = @refactor.path.split.first.to_s
      new_file = File.join(project_dir, "a/b/c/d/e.swift")
      @refactor.update_with(new_file)
      f = @refactor.swift_files.any? { |sf| sf.real_path == new_file }
      expect(f).to be true
    end
  end
end
