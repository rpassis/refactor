require "spec_helper"
require "pathname"
require "refactor/parser_result"

describe Refactor::FileUtil do

  describe "#create_file" do    
    it "creates a file at a given path and content" do
      file = "./spec/../tests/file.swift"
      contents = 
"first line 1
2
3
last line 4
"
      Refactor::FileUtil.create(file, contents)
      p = Pathname(file).expand_path
      c = File.read(p)
      expect(c).to eq(contents)
      File.delete(file)
    end
    
  end
end
