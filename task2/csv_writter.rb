# frozen_string_literal: true

require 'csv'

module CSV_writter
  # args = ['Misha', '23', 'google.com']
  def self.writter(file_name = 'test.csv', args)
    puts "Write in #{file_name}"
    # записываю данные в файл
    CSV.open(file_name, 'a') do |wr|
      args.each do |a|
        wr << a
      end
    end
  end
end
