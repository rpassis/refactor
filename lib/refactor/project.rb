require "xcodeproj"
require "pathname"

class Refactor
  class Project < Xcodeproj::Project    

    def parse
      all_new_files = []
      swift_files.each do |f| 
        filepath = f.real_path
        results = parse_file(filepath)
        next unless results.count > 0
        file_dir = File.dirname(filepath)
        new_files = FileUtil.create_files(file_dir, results)
        new_files.each { |f| puts "#{f}".green }
        all_new_files << new_files
      end
      all_new_files.flatten
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