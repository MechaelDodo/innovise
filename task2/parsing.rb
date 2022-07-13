# frozen_string_literal: true

module Parsing
  def self.parsing(link)
    puts "START PARSING: #{link}"
    puts link
    html = URI.open(link)
    Nokogiri::HTML(html)
  end

  def self.get_product_name(page)
    $name
    page.xpath('//div[@class="nombre_fabricante_bloque col-md-12 desktop"]/*').each do |div|
      $name = div.at_xpath('//h1').text.strip
    end
    $name
  end

  def self.get_product_img(page)
    $src
    page.xpath('//span[@id="view_full_size"]//img/@src').each do |src|
      $src = src.text.strip
    end
    $src
  end

  def self.get_weight_price(page)
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
    product
  end

  def self.delete_letters(product)
    puts "product[:weight]: #{product[:weight]}"
    (product[:weight].delete 'a-zA-Z,.-').split
  end

  def self.delete_numbers(product)
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

  def self.convert_weight_more(weight, price, name, weight_gr)
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

  def self.convert_weight_less(weight, price, name, weight_gr)
    weight_arr = weight[0].split('')
    weight = Array.new(price.length, weight[0])
    weight[0] = weight_arr[0, 2].join
    weight[1] = weight_arr[2, weight_arr.length].join
    weight.each_with_index do |w, i|
      weight[i] = "#{name} - #{w} #{weight_gr[i]}"
    end
    weight
  end

  def self.convert(weight, price, name, weight_gr)
    puts "weight: #{weight}, weight_gr: #{weight_gr}, price: #{price}"
    if weight.empty?
      weight = Array.new(price.length, name) # если не указаны граммовки
    elsif weight.length > price.length
      weight = convert_weight_more(weight, price, name, weight_gr)
    elsif weight.length < price.length
      weight = convert_weight_less(weight, price, name, weight_gr)
    else
      weight.each_with_index { |w, i| weight[i] = "#{name} - #{w} #{weight_gr[i]}" }
    end
    weight
  end

  def self.get_result_array(price, weight, image)
    res = Array.new(price.length)
    res.each_with_index do |_r, i|
      res[i] = [weight[i], price[i], image[i]]
    end
    res
  end

  def self.get_main_data(page)
    product = get_weight_price(page)
    $name = get_product_name(page)
    $src = get_product_img(page)
    price = product[:price].split(' €')
    weight = delete_letters(product)
    weight_gr = delete_numbers(product)
    weight_gr = Array.new(price.length, 'Cápsulas') if weight_gr.empty?
    weight = convert(weight, price, $name, weight_gr)
    image = Array.new(price.length, $src)
    get_result_array(price, weight, image)
  end
end
