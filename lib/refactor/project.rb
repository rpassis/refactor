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
        results, modified_text = parse_file(filepath)
        next unless results && results.count > 0
        file_dir = File.dirname(filepath)
        new_files = FileUtil.create_files(file_dir, results)
        original_file = FileUtil.create(filepath, modified_text, true)
        total_results << new_files
      end
      total_results.flatten!
      update_xcodeproj(total_results)
      total_results      
    end

    def swift_files
      files.reject { |f| f.path.end_with?(".swift") == false }
    end

    private

    def update_xcodeproj(new_files)
      xcpath = self.path.split.first
      new_files.each do |f|
        pathname = Pathname(f)        
        f_split = pathname.split
        relative = f_split.last
        while xcpath != f_split.first
          f_split = f_split.first.split
          relative = f_split.last.join relative
        end
        puts "Xcode project file: #{relative}".blue
        comps = relative.to_s.split("/")
        comps.pop
        comps.each do |c|
          unless group = self.main_group[c]
            group = self.main_group.new_group(c, pathname.split.first)
          end
          group.new_file(pathname)
        end
        self.save
      end
    end

    def parse_file(file)
      return unless text = File.readlines(file).join
      p = Parser.new(text)
      p.start
      return p.results, p.modified_source_text
    end

  end
end