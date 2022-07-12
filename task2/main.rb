require 'open-uri'
require 'nokogiri'
require 'yaml'
require 'thread'
require_relative 'csv_writter'
require_relative 'get_category_links'

class Product


  def run(link)
    @args = parsing(link)
  end

  def get_args
    puts 'getter'
    if defined? @args
      return @args
    else
      puts "#{self} is not defined"
      return Array.new(3)
    end
  end


  private
  def parsing(link)
    puts :START_PARSING
    puts link

    #парсинг html-странички
    html = URI.open(link)
    page = Nokogiri::HTML(html)
    product = []
    $name
    $src

    #поиск имени товара
    page.xpath('//div[@class="nombre_fabricante_bloque col-md-12 desktop"]/*').each do |div|
      $name = div.at_xpath('//h1').text.strip
    end

    #поиск картинки
    page.xpath('//span[@id="view_full_size"]//img/@src').each do |src|
      $src = src.text.strip
    end

    #поиск веса и цены
    page.xpath('//div[@class="attribute_list"]/*' ).each do |div|
      prodWeight = div.search("span.radio_label").text.strip
      prodPrice = div.search("span.price_comb").text.strip
      # в случае, когда в верстке два дива attribute_list
      if product.empty?
        product.push(
          weight: prodWeight,
          price: prodPrice
        )
        product = product[0] # из листа в словарь грубо говоря
      else
        product[:weight]+=prodWeight
        product[:price]+=prodPrice
      end
    end

    # это все Листы
    weight = product[:weight].delete "a-zA-Z.,-"
    weight = weight.split()
    price = product[:price].split(' €')
    # привожу к форме как в ТЗ
    if weight.empty?
      #если не указаны граммовки
      weight = Array.new(price.length, $name)
    else
      weight.each_with_index  do |w, i|
        weight[i]=$name+' '+w
      end
    end
    image = Array.new(price.length, $src)

    #привожу к нужному формату лист для csv
    res= Array.new(price.length)
    res.each_with_index do |r, i|
      res[i] = [weight[i], price[i], image[i]]
    end
    puts "Parsing result: #{res}"
    return res
  end
end


if __FILE__ == $0
  #yml_args = YAML.load_file('arguments.yml')
  #category_link = yml_args['category_link']
  #file_name = yml_args['file_name']
  links = GET_category_links.get_links('https://www.petsonic.com/farmacia-para-gatos/?categorias=cicatrizantes-para-gatos')
  threads = []
  start = Time.now
  links.each do |link|
    p = Product.new
    threads << Thread.new do
      p.run(link)
      CSV_writter.writter('test.csv', p.get_args)
    end
    threads.map(&:join)
  end
  puts "#{Time.now - start}"

end
