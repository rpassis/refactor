class Parser
  class Result
    attr_accessor :name, :lines

    def initialize(name, lines)
      @name = name
      @lines = lines
    end
  end
end