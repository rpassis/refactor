require "xcodeproj"

class Refactor
  class Project < Xcodeproj::Project    
    #
    # This is the main entry point for *refactor*, which is a subclass of Xcodeproj::Project
    # When parse is called on an instance of this type, we fetch all swift files that are
    # part of the project and start searching for parsing "tokens". 
    # When tokens are found the enclosing text is collecting and assigned a filename (and) path
    #      
    # Each result is encapsulated into a Parser::Result object
    # The parse method uses those results to create each new file and inject 
    # the parsed text into them
    #
    # Once all files are successfully created, we use Xcodeproj native functionality to insert
    # them into the appropriate groups within the project, and finally save the resulting project
    #
    def parse
      swift_files.each do |f| 
        original_filepath = f.real_path
        results, modified_text = parse_file(original_filepath)
        next unless results && results.count > 0
        original_file_dir = File.dirname(original_filepath)
        # Create new files starting from the original file folder and appending the
        # relative filename specified in the each of the results array
        new_files = create_new_files(original_file_dir, results)
        # Update and save the xcodeproj with the new files and their respective groups
        new_files.each { |nf| update_with(nf) }
        # Once all the new files have been created, we need to remove the parsed text
        # from the original file
        FileUtil.create(original_filepath, modified_text, overwrite = true)
        # And finally save
        save
      end
    end

    # Filter all project files by extension and reject anything that doesn't end with .swift
    def swift_files
      files.reject { |f| f.path.end_with?(".swift") == false }
    end    

    def update_with(new_file)
      pathname = Pathname(new_file).expand_path     
      xcpath = self.path.split.first            
      unless pathname.is_underneath?(xcpath)
        puts "#{pathname} is outside of the project folder hierarchy, skipping...".red
        return
      end            
      f_split = pathname.split
      filename = f_split.last      
      base = f_split.first
      relative_path_components = []
      while xcpath != base        
        relative_path_components.unshift(base.split.last.to_s)
        base = base.split.first        
      end
      file_group = self.main_group
      relative_path_components.each do |p|
        unless new_file_group = file_group[p]
          new_file_group = file_group.new_group(p)          
        end
        file_group = new_file_group
      end
      file_group.new_file(pathname)      
    end

    private

    def create_new_files(dir, parser_results)
      files = []      
      parser_results.each do |p|
        filename = p.name
        contents = p.lines
        file_path = Pathname(File.join(dir, filename)).expand_path
        unless is_underneath_project_path?(file_path)
          puts "#{file_path} is outside of the project folder hierarchy, skipping...".red
          next
        end
        puts "Creating new file: #{file_path}".yellow
        FileUtil.create(file_path, contents)
        files << file_path
      end
      files
    end

    def parse_file(file)
      return unless text = File.readlines(file).join
      Parser.process(text)      
    end

    def is_underneath_project_path?(pathname)
      pathname.is_underneath?(self.path.dirname)
    end
    
  end
end
