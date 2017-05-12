require_relative 'lib/lazada/scraper'

page = 1
puts "page #{page}"
ex = LzdScraper.new(page)
File.write("lib/data/#{page}.json", ex.get_all_reviews.to_json)