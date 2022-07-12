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
  puts "product[:weight]: #{product[:weight]}"
  weight = product[:weight].delete "a-zA-Z,.-"
  weight = weight.split()
  #weight_gr = product[:weight].delete "0-9"
  weight_gr = product[:weight]
  weight_gr = weight_gr.split('')
  weight_gr.each_with_index do |ch, i|
    ch = ch.delete "0-9-"
    if ch == ''
      weight_gr[i] = ch+' '
    else
      weight_gr[i] = ch
    end
  end
  weight_gr = weight_gr.join
  weight_gr = weight_gr.split()
  price = product[:price].split(' €')
  weight_gr = Array.new(price.length, 'Cápsulas') if weight_gr.empty?
  puts "weight: #{weight}, weight_gr: #{weight_gr}, price: #{price}"
  # привожу к форме как в ТЗ
  if weight.empty?
    #если не указаны граммовки
    weight = Array.new(price.length, $name)
  elsif weight.length > price.length
    # wight: ["6", "2", "6", "4"], weight_gr: ["Pipetas", "ml", "Pipetas", "ml"], price: ["20.82", "26.02"]
    weight_new = Array.new(price.length)
    i = 0
    j = 0
    while i <= price.length
      weight_new[j] = $name+' - '+weight[i]+' '+weight_gr[i]+' - '+weight[i+1]+' '+weight_gr[i+1]
      i+=2
      j+=1
    end
    weight = weight_new
  elsif weight.length < price.length
    # weight: ["30120"], weight_gr: ["Cápsulas", "Cápsulas"], price: ["11.95", "37.95"]
    weight_arr = weight[0].split('')
    weight = Array.new(price.length, weight[0])
    weight[0] = weight_arr[0,2].join
    weight[1] = weight_arr[2, weight_arr.length].join
    weight.each_with_index  do |w, i|
      weight[i]=$name+' - '+w+' '+weight_gr[i]
    end
  else
    weight.each_with_index  do |w, i|
      weight[i]=$name+' - '+w+' '+weight_gr[i]
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
  #создаю файл
  # products = []
  # products.push name: "name", price: "price", image: "image"
  # CSV.open(file_name, "a", write_headers: true, headers: products.first.keys) do |wr|
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
  puts "Введите ссылку на каталог с сайта www.petsonic.com:"
  category_link = gets.chomp
  puts "Введите введите имя csv-файла:"
  csv_name = gets.chomp+'.csv'
  category_links = get_links(category_link)
  start = Time.now
  category_links.each do |link|
    data = parsing(link)
    csv_write(csv_name, data)
  end
  puts "#{Time.now - start}"
  ###
  #parsing('https://www.petsonic.com/stanvet-condrocit-para-perro-yo-gato.html')


end



