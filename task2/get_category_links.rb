module GET_category_links
  def self.get_links(category_link)
    #парсинг html-странички
    html = URI.open(category_link)
    page = Nokogiri::HTML(html)
    $links = Array.new

    page.xpath('//li[contains(@class, "ajax_block_product")]/div[@class="product-container"]/*/
div[contains(@class, "product-desc")]/a/@href').each {|href| $links.append(href)}
    return  $links
  end
end
