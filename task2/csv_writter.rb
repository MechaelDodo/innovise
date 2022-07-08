require 'csv'

module CSV_writter
  def self.writter(file_name='test.csv', args)  # args = ['Misha', '23', 'google.com']
    puts "Write in #{file_name}"
    #записываю данные в файл
    CSV.open(file_name, "a") do |wr|
      args.each do |a|
        wr << a
      end
    end
  end
end
