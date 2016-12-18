require "pathname"

class Refactor
  module FileUtil
    def self.create_files(original_file_dir, parsed_results)
      files = []      
      parsed_results.each do |p|
        file_path = File.join(original_file_dir, p.name)
        puts "Creating new file: #{p.name}".yellow
        create(file_path, p.lines)
        files << file_path
      end
      files
    end

    def self.create(file_path, content, overwrite = false)
      if File.exists?(file_path) && overwrite == false
        puts "Destination file already exists at #{file_path}, skipping...".yellow
        return
      end
      create_folder_if_required(File.dirname(file_path))
      File.open(file_path, "w+") { |f| f.puts(content) }    
    end
    
    private
  
    def self.create_folder_if_required(dirname)
      unless File.directory?(dirname)
        FileUtils.mkdir_p(dirname)
      end
    end
  end
end
