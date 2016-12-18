require 'refactor/parser_result'

class Parser

  TRIGGER_STRING  = "//FILE:"
  BLOCK_NAME_REGEXP = /\.(swift)$/

  attr_reader :text, :lines, :modified_source_text

  def initialize(text)
    @text = text
    @lines = text.split("\n")
  end
    
  def start
    found_indexes = []
    lines.each_with_index do |l, i| 
      found_indexes << i if parse_line(l) == true          
    end    
    modified_original_text(found_indexes) if found_indexes.count > 0
  end

  def results
    @results ||= []
  end

  def self.process(text)
    p = Parser.new(text)
    p.start && p.results
  end
  
  private

  def modified_original_text(indexes_to_remove)
    new_lines = lines.reject.with_index { |l, i| indexes_to_remove.include? i }    
    @modified_source_text = new_lines.join("\n")
  end

  def parse_line(l)
    # Trigger found, let's start by setting the block name
    # and creating a new array for the block's lines of text
    if find_trigger(l) == true 
      set_block_name(l)
      @block_lines = []
      @token_count = 0
      return true
    end
    return false if @block_name.nil?
    @token_count += l.count("{") # Increase count for opening {
    @token_count -= l.count("}") # Decrease count for closing }
    @block_lines << l unless @block_name.nil?
    # When token_count == 0 we are done with the block
    if @token_count == 0
      results << Result.new(@block_name, @block_lines)       
      @block_name = nil
    end
    return true
  end

  def find_trigger(l)
    true if l.include? TRIGGER_STRING
  end

  # Sets the name of the block of code that is about to get parsed
  def set_block_name(l)
    name = l.split(" ").last.strip
    @block_name = name if name =~ BLOCK_NAME_REGEXP 
  end
end
