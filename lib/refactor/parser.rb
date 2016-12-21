require 'refactor/parser_result'

class Parser

  START_TRIGGER_STRING  = "// FILE:"
  END_TRIGGER_STRING = "// END"
  BLOCK_NAME_REGEXP = /\.(swift)$/

  attr_reader :text, :lines, :modified_source_text

  def initialize(text)
    @text = text
    @lines = text.split("\n")
  end
    
  def start
    original_lines_to_remove = []
    lines.each_with_index do |l, i| 
      original_lines_to_remove << i if parse_line(l) == true          
    end    
    set_modified_source_text_with(original_lines_to_remove) if \
    original_lines_to_remove.count > 0
  end

  def results
    @results ||= []
  end

  def self.process(text)
    p = Parser.new(text)
    p.start
    return p.results, p.modified_source_text
  end
  
  private

  def set_modified_source_text_with(indexes_to_remove)
    new_lines = lines.reject.with_index { |l, i| indexes_to_remove.include? i }    
    @modified_source_text = new_lines.join("\n")
  end

  def parse_line(l)
    # Trigger found, let's start by setting the block name
    # and creating a new array for the block's lines of text
    if find_trigger(l) == true 
      set_block_name(l)
      @block_lines = []
      return true
    end
    return false if @block_name.nil?
    if find_end_trigger(l) == true
      results << Result.new(@block_name, @block_lines)
      @block_name = nil
      return true
    end
    @block_lines << l
    return true
  end

  def find_trigger(l)
    true if l.include? START_TRIGGER_STRING
  end

  def find_end_trigger(l)
    true if l.include? END_TRIGGER_STRING
  end

  # Sets the name of the block of code that is about to get parsed
  def set_block_name(l)
    name = l.split(" ").last.strip
    @block_name = name if name =~ BLOCK_NAME_REGEXP 
  end
end
