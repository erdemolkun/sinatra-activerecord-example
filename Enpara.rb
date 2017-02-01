class Enpara
  
  def rate
    begin
      response = HTTParty.get 'http://www.finansbank.enpara.com/doviz-kur-bilgileri/doviz-altin-kurlari.aspx'
      doc = Nokogiri::HTML response
      result = String.new
      dollar_buy = nil
      dollar_sell = nil
      eur_buy = nil
      eur_sell = nil
      doc.css('#pnlContent span dl').each do |row|
        if (row.css('dt').text)=="USD"
          dollar_buy = row.css('dd').first.text.split(' ').first
          dollar_sell = row.css('dd').last.text.split(' ').first
          # result+="#{row.css('dd').first.text.split(' ').first} : #{row.css('dd').last.text.split(' ').first}"
        elsif (row.css('dt').text)=="EUR"
          # result+=" - #{row.css('dd').first.text.split(' ').first} : #{row.css('dd').last.text.split(' ').first}"
          eur_buy = row.css('dd').first.text.split(' ').first
          eur_sell = row.css('dd').last.text.split(' ').first
        end 
      end
      {dollar_sell: dollar_sell, dollar_buy: dollar_buy,eur_buy: eur_buy,eur_sell: eur_sell}.to_json
    rescue Exception => e
      puts e
      "Error Occured!!!"
    end 
  end

end