require "xcodeproj"
require "pathname"

class Refactor
  class Project < Xcodeproj::Project    

    def parse
      files.each do |f| 
        next unless f.path.end_with?(".swift") 
        filepath = f.real_path
        results = parse_file(filepath)
        file_dir = File.dirname(filepath)
        puts "Creating the following files at #{file_dir}: #{results}".green
        new_files = FileUtil.create_files(file_dir, results)
        new_files.each { |f| puts "#{f}".green }
        true
      end
      true
    end

    private

    def parse_file(file)
      return unless text = File.readlines(file).join
      Parser.process(text)
    end

  end
end