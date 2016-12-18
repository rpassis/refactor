class Refactor
  
  attr_reader :options, :files

  def initialize(options = {})
    @options = Options.with_defaults(options)
    @files = Dir["#{@options[:path]}/**/*.swift"]
  end

  def parse  
    files.each do |f| 
      results = parse_file(f)
      file_dir = File.dirname(f)
      new_files = FileUtil.create_files(file_dir, results)
      return update_project(new_files)
    end
  end

  private

  def update_project(files)
    puts "Update project".red
    puts "#{files}".yellow
    # p = Refactor::Project.open("./RefactorSampleProject.xcodeproj")
    # p.new_file(path)
    true
  end

  def parse_file(file)
    return unless text = File.readlines(file).join
    Parser.process(text)
  end

  def start_trigger(l)
    true if l.include? '//FILE'
  end

  def end_trigger(l)
    true if l.include? '//END'
  end

end
