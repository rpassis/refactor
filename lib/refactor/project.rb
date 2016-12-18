require "xcodeproj"
require "pathname"

class Refactor
  class Project < Xcodeproj::Project    

    # Parses each swift file within the project
    # Create new files as needed and returns a flattened
    # array of all files created
    def parse
      total_results = []      
      swift_files.each do |f| 
        filepath = f.real_path
        results = parse_file(filepath)
        next unless results.count > 0
        file_dir = File.dirname(filepath)
        new_files = FileUtil.create_files(file_dir, results)
        total_results << new_files
      end
      total_results.flatten
    end

    def swift_files
      files.reject { |f| f.path.end_with?(".swift") == false }
    end

    private

    def parse_file(file)
      return unless text = File.readlines(file).join
      Parser.process(text)
    end

  end
end