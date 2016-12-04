$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "refactor"

def fixture_path(*path)
  File.join(File.dirname(__FILE__), 'fixtures', *path)
end
