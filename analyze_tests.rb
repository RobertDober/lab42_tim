require_relative 'test_result_parser'


BASE_DIR = File.dirname __FILE__
TMP_DIR  = File.join BASE_DIR, 'tmp'


test_results = Dir.glob File.join TMP_DIR, 'test_result_*'


parser = TestResultParser.new

test_results.each do | test_result |
  parser.parse File.readlines test_result
end

parser.resumee
