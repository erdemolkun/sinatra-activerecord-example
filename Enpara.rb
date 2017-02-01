require 'byebug'

require './buysellrate'
require './rateholder'
require './rateholderwithtime'

class Fetcher
  class << self
    attr_accessor :array_with_time
  end

  def get_from_cache
    if self.class.array_with_time.present? 
      diff = (Time.now - self.class.array_with_time.time).to_f
      #puts "Time Diff #{diff}"
      if diff < 1.25 # Defined in milliseconds
        puts "Using cache"
        return self.class.array_with_time.anything  
      end
    else
      return false
    end
  end

  def cache!(anything)
    self.class.array_with_time = RateHolderWithTime.new(Time.now, anything)
    anything
  end
end

class Enpara < Fetcher
  
  URL = 'http://www.finansbank.enpara.com/doviz-kur-bilgileri/doviz-altin-kurlari.aspx'

  def all_rates
    puts "Time Current ->> #{Time.current.strftime('%Y-%m-%dT%H:%M:%S.%L')}" 
    
    cached = get_from_cache
    return cached if cached
    
    puts "Started Fetching Response"
    response = HTTParty.get URL
    doc = Nokogiri::HTML response
    rates = Array.new
    
    doc.css('#pnlContent span dl').each do |row|
      if (row.css('dt').text) == "USD"
        rate = parse_rate(row)
        rates << RateHolder.new(1,rate)
      elsif (row.css('dt').text)=="EUR"
        rate = parse_rate(row)
        rates << RateHolder.new(2,rate)
      end 
    end
    cache! rates
  rescue Exception => e
     puts e
  end

  private

  def parse_rate(row)
    BuySellRate.new(row.css('dd').first.text.split(' ').first, row.css('dd').last.text.split(' ').first)
  end

end