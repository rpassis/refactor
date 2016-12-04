class Refactor
  module FileUtil
    def self.create_files(original_file_dir, parsed_results)
      files = []      
      parsed_results.each do |p|
        file_path = original_file_dir + p.name        
        create(file_path, p.lines)
        files << file_path
      end
      files
    end

    private

    def self.create(file_path, content)
      create_folder_if_required(File.dirname(file_path))
      File.open(file_path, "w+") { |f| f.puts(content) }    
    end

    def self.create_folder_if_required(dirname)
      unless File.directory?(dirname)
        FileUtils.mkdir_p(dirname)
      end
    end
  end
end
