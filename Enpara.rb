require './BuySellRate'
require './RateHolder'
require './ArrayWithTime'

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
          return Enpara.array_with_time.array  
        end
      end
      
      puts "Fetching New Data"
      response = HTTParty.get 'http://www.finansbank.enpara.com/doviz-kur-bilgileri/doviz-altin-kurlari.aspx'
      doc = Nokogiri::HTML response
      rate_array = Array.new
      
      doc.css('#pnlContent span dl').each do |row|

        if (row.css('dt').text) == "USD"

          rateholder = RateHolder.new
          rate = BuySellRate.new
          rate.buy = row.css('dd').first.text.split(' ').first;
          rate.sell = row.css('dd').last.text.split(' ').first;
          rateholder.type = 1
          rateholder.rate = rate
          rate_array << rateholder

        elsif (row.css('dt').text)=="EUR"

          rateholder = RateHolder.new
          rate = BuySellRate.new
          rate.buy = row.css('dd').first.text.split(' ').first
          rate.sell = row.css('dd').last.text.split(' ').first
          rateholder.type = 2
          rateholder.rate = rate
          rate_array << rateholder
        end 
      end
      #{dollar_sell: dollar_sell, dollar_buy: dollar_buy,eur_buy: eur_buy,eur_sell: eur_sell}.to_json
      Enpara.array_with_time = ArrayWithTime.new
      Enpara.array_with_time.array = rate_array
      Enpara.array_with_time.time = Time.now

      rate_array
    rescue Exception => e
      puts e
      "Uknown error!!!"
    end 
  end


end