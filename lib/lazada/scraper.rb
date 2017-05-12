require 'nokogiri'
require 'open-uri'
require 'json'

class LzdScraper 
  def initialize(page)
    @page = page.to_s
    @doc = Nokogiri::HTML(open("http://www.lazada.vn/may-anh-may-quay-phim/?itemperpage=120&page=#{@page}&searchContext=category"))
    @product_paths = get_product_paths
  end

  def get_all_reviews
    reviews = []
    count = 1
    @product_paths.each do |path|
      puts count
      count += 1
      review = {}
      review[:product_name] = path.split('-').join(' ')
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

    def get_product_paths
      @doc.css('.c-product-list>.c-product-card>.c-product-card__img-placeholder>a').map { |e| e.values.first  }
    end  
end