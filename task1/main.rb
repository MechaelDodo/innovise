# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'
require 'csv'

# парсинг html-странички
def one_page_parsing(link)
  puts "START PARSING: #{link}"
  html = URI.open(link)
  Nokogiri::HTML(html)
end

# возвращает список с ссылками на страницы
def get_links_from_category(link_category)
  # PAGINATION!!!
  page = one_page_parsing(link_category)
  links = []
  page.xpath('//li[contains(@class, "ajax_block_product")]/div[@class="product-container"]/*/
div[contains(@class, "product-desc")]/a/@href').each { |href| links.append(href) }
  num_of_products = page.xpath('//input[@id = "nb_item_bottom"]/@value').text.to_i
  num_of_pages = (num_of_products / 25.0).ceil
  (2..num_of_pages).each do |page_num|
    result_link_to_category = link_category + "?p=#{page_num}"
    one_page_parsing(result_link_to_category).xpath('//li[contains(@class, "ajax_block_product")]/
div[@class="product-container"]/*/div[contains(@class, "product-desc")]/a/@href').each { |href| links.append(href) }
  end
  links
end



# поиск имени товара !!!
def get_product_name(page)
  $name
  page.xpath('//div[@class="nombre_fabricante_bloque col-md-12 desktop"]/*').each do |div|
    $name = div.at_xpath('//h1').text.strip
  end
  $name
end

# поиск картинки
def get_product_img(page)
  $src
  page.xpath('//span[@id="view_full_size"]//img/@src').each do |src|
    $src = src.text.strip
  end
  $src
end

# возвращает список с граммовкой и ценой
def get_weight_and_price(page)
  product = []
  page.xpath('//div[@class="attribute_list"]/*').each do |div|
    prod_weight = div.search('span.radio_label').text.strip
    prod_price = div.search('span.price_comb').text.strip
    if product.empty?         # в случае, когда в верстке два дива attribute_list
      product.push(weight: prod_weight, price: prod_price)
      product = product[0]    # из листа в словарь грубо говоря
    else
      product[:weight] += prod_weight
      product[:price] += prod_price
    end
  end
  puts "PRODUCT #{product}"
  product
end

def delete_letters_for_weight(product)
  puts "product[:weight]: #{product[:weight]}"
  (product[:weight].delete 'a-zA-Zñ,.-').split
end

def delete_numbers_for_weight(product)
  weight_gr = product[:weight].split('')
  weight_gr.each_with_index do |ch, i|
    ch = ch.delete '0-9-'
    weight_gr[i] = if ch == ''
                     "#{ch} "
                   else
                     ch
                   end
  end
  weight_gr.join.split
end

# wight: ["6", "2", "6", "4"], weight_gr: ["Pipetas", "ml", "Pipetas", "ml"], price: ["20.82", "26.02"]
def convert_weight_more_price(weight, price, name, weight_gr)
  weight_new = Array.new(price.length)
  i = 0
  j = 0
  while i <= price.length
    weight_new[j] = "#{name} - #{weight[i]} #{weight_gr[i]} - #{weight[i + 1]} #{weight_gr[i + 1]}"
    i += 2
    j += 1
  end
  weight_new
end

# weight: ["30120"], weight_gr: ["Cápsulas", "Cápsulas"], price: ["11.95", "37.95"]
def convert_weight_less_price(weight, price, name, weight_gr)
  weight_arr = weight[0].split('')
  weight = Array.new(price.length, weight[0])
  weight[0] = weight_arr[0, 2].join
  weight[1] = weight_arr[2, weight_arr.length].join
  weight.each_with_index do |w, i|
    weight[i] = "#{name} - #{w} #{weight_gr[i]}"
  end
  weight
end

# привожу к форме как в ТЗ
def convert_all_objects_for_technical_task(weight, price, name, weight_gr)
  puts "weight: #{weight}, weight_gr: #{weight_gr}, price: #{price}"
  if weight.empty?
    weight = Array.new(price.length, name) # если не указаны граммовки
  elsif weight.length > price.length
    weight = convert_weight_more_price(weight, price, name, weight_gr)
  elsif weight.length < price.length
    weight = convert_weight_less_price(weight, price, name, weight_gr)
  else
    weight.each_with_index { |w, i| weight[i] = "#{name} - #{w} #{weight_gr[i]}" }
  end
  weight
end

# привожу к нужному формату лист для csv
def get_result_array(price, weight, image)
  res = Array.new(price.length)
  res.each_with_index do |_r, i|
    res[i] = [weight[i], price[i], image[i]]
  end
  res
end

def get_main_data(link)
  page = one_page_parsing(link)
  product = get_weight_and_price(page)
  $name = get_product_name(page)
  $src = get_product_img(page)
  price = product[:price].split(' €')
  weight = delete_letters_for_weight(product)
  weight_gr = delete_numbers_for_weight(product)
  weight_gr = Array.new(price.length, 'Cápsulas') if weight_gr.empty?
  weight = convert_all_objects_for_technical_task(weight, price, $name, weight_gr)
  image = Array.new(price.length, $src)
  get_result_array(price, weight, image)
end

# записываю данные в файл
def csv_write(pars_arr, file_name = 'test.csv')
  puts "Write in #{file_name}"
  CSV.open(file_name, 'a') do |wr|
    pars_arr.each do |a|
      wr << a
    end
  end
end

def main
  puts 'Введите ссылку на каталог с сайта www.petsonic.com:'
  category_link = gets.chomp
  puts 'Введите введите имя csv-файла:'
  csv_name = "#{gets.chomp}.csv"
  category_links = get_links_from_category(category_link)
  category_links.each do |link|
    data = get_main_data(link)
    csv_write(data, csv_name)
  end
end
main
