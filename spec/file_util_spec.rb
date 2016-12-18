require "spec_helper"
require "refactor/parser_result"

describe Refactor::FileUtil do

  describe "#create_files" do    
    it "creates files in their respective paths" do
      f = "./spec/../tests/file.swift"
      r = Parser::Result.new("test.swift", ["first line 1","2","3","last line 4"])
      parser_results = [r]   
      files = Refactor::FileUtil.create_files(f, parser_results)
      expect(files.count).to eq(parser_results.count) 
      files.each { |f| File.delete(f) }
    end
    
  end
end
