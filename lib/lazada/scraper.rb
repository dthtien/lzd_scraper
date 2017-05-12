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
    data_reviews = []
    count = 1
    @product_paths.each do |path|
      puts count
      count += 1
      review_product = {}
      break if get_review_per_page(path).nil?
      review_product[:product_name] = path.split('-').join(' ')
      review_product[:content] = get_review_per_page(path)
      data_reviews << review_product
    end
    data_reviews
  end

  private
    def get_review_per_page(path)
      reviews = []
      doc = Nokogiri::HTML(open("http://www.lazada.vn#{path}"))
      rating = doc.css('.ratingNumber>em')
      return nil if rating.nil? && rating.text.to_f < 3.0
      doc.css('.ratRev_reviewListRow>.ratRev_revDetail').each do |review|
        reviews << review.text
      end
      reviews
    end

    def get_product_paths
      @doc.css('.c-product-list>.c-product-card>.c-product-card__img-placeholder>a').map { |e| e.values.first  }
    end  
end