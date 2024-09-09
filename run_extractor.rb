# run_extractor.rb
require_relative 'lib/services/html_extractor_service'

file_path = File.expand_path('files/van-gogh-paintings.html', __dir__)

extractor = HtmlExtractorService.new(file_path)
result = extractor.extract

puts result
