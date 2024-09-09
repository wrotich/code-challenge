require 'nokogiri'
require 'open-uri'
require 'base64'

class HtmlExtractorService
	def initialize(file_path)
		@file_path = file_path
	end

	def extract
		html_content = File.read(@file_path)
		document = Nokogiri::HTML(html_content)

		artworks = document.css('a').map do |item|
			next unless item.attribute('aria-label') || item.attribute('title') # Skip items without a label or title

			{
				"name" => extract_name(item),
				"extensions" => extract_extensions(item),
				"link" => extract_link(item),
				"image" => extract_image(item)
			}
		end.compact

		{ "artworks" => artworks }
	end

	private

	def extract_name(item)
		item.attribute('aria-label')&.value&.strip || item.attribute('title')&.value&.strip
	end

	def extract_extensions(item)
		item.css('span, div').map(&:text).map(&:strip).reject(&:empty?)
	end

	def extract_link(item)
		item.attribute('href')&.value
	end

	def extract_image(item)
		image_url = item.css('img').attribute('data-src')&.value || item.css('img').attribute('src')&.value
		return unless image_url

		begin
			image_data = URI.open(image_url).read
			"data:image/jpeg;base64,#{Base64.encode64(image_data)}"
		rescue
			nil
		end
	end
end
