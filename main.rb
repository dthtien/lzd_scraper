require_relative 'lib/lazada/scraper'

# page = 1
# puts "page #{page}"
# ex = LzdScraper.new(page)
# File.write("lib/data/#{page}.json", ex.get_all_reviews.to_json)
#

sku = 'NE644ELAA1U825VNAMZ'
p LzdScraper.get_data_from(sku)
