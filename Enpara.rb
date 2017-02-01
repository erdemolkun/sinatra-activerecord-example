require './buysellrate'
require './rateholder'
require './rateholderwithtime'

class Enpara
  
def self.array_with_time
  return @array_with_time
end

def self.array_with_time=(value)
  @array_with_time = value
end

  def get_rate
    begin
      puts Time.current
      puts "Start Function"
      if Enpara.array_with_time.present? 
        diff=(Time.now-Enpara.array_with_time.time).to_f
        #puts "Time Diff #{diff}"
        if diff < 1.25 # Defined in milliseconds
          puts "Using cache"
          return Enpara.array_with_time.anything  
        end
      end
      
      puts "Fetching New Data"
      response = HTTParty.get 'http://www.finansbank.enpara.com/doviz-kur-bilgileri/doviz-altin-kurlari.aspx'
      doc = Nokogiri::HTML response
      rates = Array.new
      
      doc.css('#pnlContent span dl').each do |row|

        if (row.css('dt').text) == "USD"
          rate = BuySellRate.new(row.css('dd').first.text.split(' ').first,row.css('dd').last.text.split(' ').first)
          rates << RateHolder.new(1,rate)
        elsif (row.css('dt').text)=="EUR"
          rate = BuySellRate.new(row.css('dd').first.text.split(' ').first,row.css('dd').last.text.split(' ').first)
          rates << RateHolder.new(2,rate)
        end 
      end
      #{dollar_sell: dollar_sell, dollar_buy: dollar_buy,eur_buy: eur_buy,eur_sell: eur_sell}.to_json
      Enpara.array_with_time = RateHolderWithTime.new(Time.now,rates)
      rates
    rescue Exception => e
      puts e
      "Uknown error!!!"
    end 
  end

end