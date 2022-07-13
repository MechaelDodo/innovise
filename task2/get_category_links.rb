# frozen_string_literal: true

require_relative 'parsing'

module GET_category_links
  def self.get_links(category_link)
    page = Parsing.parsing(category_link)
    $links = []
    page.xpath('//li[contains(@class, "ajax_block_product")]/div[@class="product-container"]/*/
div[contains(@class, "product-desc")]/a/@href').each { |href| $links.append(href) }
    $links
  end
end
