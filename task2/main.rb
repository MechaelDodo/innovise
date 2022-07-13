# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'
require 'yaml'
require_relative 'csv_writter'
require_relative 'get_category_links'
require_relative 'parsing'

class Product
  def initialize(file_name, data)
    @file_name = file_name
    @data = data
  end

  def run
    CSV_writter.writter(@file_name, @data)
  end
end

def main
  yml_args = YAML.load_file('arguments.yml')
  category_link, file_name  = yml_args['category_link'], yml_args['file_name']
  links = GET_category_links.get_links(category_link)
  threads, pages = [], []
  start = Time.now
  links.each do |link|
    threads << Thread.new do
      pages.append(Parsing.parsing(link))
    end
    threads.map(&:join)
  end
  threads = []
  pages.each do |page|
    threads << Thread.new do
      p = Product.new(file_name = file_name, Parsing.get_main_data(page)); p.run
      p.run
    end
    threads.map(&:join)
  end
  puts (Time.now - start).to_s
end

main
