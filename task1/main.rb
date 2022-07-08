require 'open-uri'
require 'nokogiri'
require 'csv'

def get_links(category_link)
  #парсинг html-странички
  html = URI.open(category_link)
  page = Nokogiri::HTML(html)
  $links = Array.new

  page.xpath('//li[contains(@class, "ajax_block_product")]/div[@class="product-container"]/*/
div[contains(@class, "product-desc")]/a/@href').each {|href| $links.append(href)}
  return  $links
end

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

def csv_write(file_name = 'test.csv', pars_arr)
  puts "Write in #{file_name}"
  # #создаю файл
  # products = []
  # products.push name: "name", price: "price", image: "image"
  # CSV.open(file_name, "w", write_headers: false, headers: products.first.keys) do |wr|
  #   products.each do |p|
  #     wr << p.values
  #   end
  # end

  #записываю данные в файл
  CSV.open(file_name, "a") do |wr|
      pars_arr.each do |a|
          wr << a
        end
  end
end

if __FILE__ == $0
  puts "Введите ссылку на каталог с сайта ww.petsonic.com:"
  category_link = gets.chomp
  puts "Введите введите имя csv-файла:"
  csv_name = gets.chomp+'.csv'
  category_links = get_links(category_link)
  category_links.each do |link|
    data = parsing(link)
    csv_write(csv_name, data)
  end

=begin
  category_links = get_links('https://www.petsonic.com/farmacia-para-gatos/?categorias=cardiacos-para-gatos,dermatitis-y-problemas-piel-para-gatos')
  category_links.each do |link|
    data = parsing(link)
    csv_write(data)
  end
=end
end



