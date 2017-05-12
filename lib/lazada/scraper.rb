require 'nokogiri'
require 'open-uri'
require 'json'

class LzdScraper
  HOST = 'http://www.lazada.vn'
  CAMERA_URLS = "#{HOST}/may-anh-may-quay-phim/?itemperpage=120"

  def initialize(page)
    @page = page.to_s
  end

  def get_all_reviews
    product_urls = get_product_urls
    reviews = []
    count = 1

    product_urls.each do |url|
      puts count
      count += 1

      review = {}
      review[:product_name] = url.split('-').join(' ')
      review[:content] = get_review_per_page(path)
      reviews << review
    end
    reviews
  end

  private
    def get_review_per_page(path)
      doc = Nokogiri::HTML(open("http://www.lazada.vn#{path}"))
      rating = doc.css('.ratingNumber>em')
      return nil if rating.nil? && rating.text.to_f < 3.0
      doc.css('.ratRev_reviewListRow>.ratRev_revDetail').text
    end

    def get_product_urls
      doc = Nokogiri::HTML open(CAMERA_URLS)
      doc.css('.c-product-card__name')
        .map { |name| HOST + name.attr('href').strip }
    end
end
