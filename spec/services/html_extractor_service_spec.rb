require 'rspec'
require_relative '../../lib/services/html_extractor_service'

RSpec.describe HtmlExtractorService do
	let(:file_path) { File.expand_path('../../../files/van-gogh-paintings.html', __FILE__) }
	let(:extractor) { described_class.new(file_path) }

	describe '#extract' do
		it 'extracts the artwork information correctly' do
			result = extractor.extract

			expect(result).to be_a(Hash)
			expect(result['artworks']).to be_an(Array)

			expect(result['artworks'].first).to have_key('name')
			expect(result['artworks'].first).to have_key('extensions')
			expect(result['artworks'].first).to have_key('link')
			expect(result['artworks'].first).to have_key('image')
		end
	end
end
