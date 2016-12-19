require "pathname"

class Refactor
  module FileUtil
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
