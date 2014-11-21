require 'nokogiri'
require 'open-uri'

class NtustNews

  attr_accessor :news, :news_urls

  def initialize
    @news_urls = [
      'http://www.ntust.edu.tw/files/40-1000-167-1.php',
      'http://www.ntust.edu.tw/files/40-1000-167-2.php',
      'http://www.ntust.edu.tw/files/40-1000-167-3.php',
      'http://www.ntust.edu.tw/files/40-1000-167-4.php',
      'http://www.ntust.edu.tw/files/40-1000-167-5.php',
      'http://www.ntust.edu.tw/files/40-1000-167-6.php',
    ]
    @news = []
  end


  def load_news
    @news_urls.each do |news_url|
      doc = Nokogiri::HTML(open(news_url))

      t = doc.xpath('//table[@summary="list"]//td[@valign="top"][not(@width)]//div[@class="h5"]')
      title_raws = t.map { |title| title.content.gsub(/\s+/, "") }
      t = doc.xpath('//table[@summary="list"]//td[@valign="top"][not(@width)]//div[@class="h5"]//a/@href')
      urls = t.map { |url|  url.value}
      s = doc.xpath('//table[@summary="list"]//td[@valign="top"][not(@width)]//div[@class="message"]')
      summaries = s.map { |ss|  ss.text.gsub(/\s+/, "")}

      titles = title_raws.map { |t|
        start = t.index("[")
        endd = t.index("]")
        t[0..start-1]
      }  

      dates = title_raws.map { |t|
        start = t.index("[")
        endd = t.index("]")
        t[start+1..endd-1]
      }    


      for i in 0..titles.length-1
        h = Hash.new
        h[:short_title] = titles[i]
        h[:summary] = summaries[i]
        h[:date] = dates[i]
        h[:url] = urls[i]
        @news.push(h)
      end

      @news.each do |n|
        doc = Nokogiri::HTML(open(n[:url]))
        ps = doc.xpath('//div[contains(@class, "ptcontent")]//p')
        n[:title] = ps.first.text
        article = ""
        for i in 1..ps.length-1 
          article += "#{ps[i].text}\n"
        end
        n[:article] = article
      end

    end
  end

end
